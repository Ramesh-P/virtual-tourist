//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/5/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: PhotoAlbumViewController
class PhotoAlbumViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pin: Pin?
    var address: String = String()
    var isEditingPhotos: Bool = Bool()
    
    // MARK: Outlets
    @IBOutlet weak var album: UICollectionView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var photoAction: UIBarButtonItem!
    @IBOutlet weak var addNewPhotos: UIBarButtonItem!
    @IBOutlet weak var deletePhotos: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func editPhotos(_ sender: UIBarButtonItem) {
        
        // Toggle user actions and display edit status & message
        isEditingPhotos = !isEditingPhotos
        
        setActions()
        displayEditStatus()
    }
    
    @IBAction func addNewPhotoCollection(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func deleteSelectedPhotos(_ sender: UIBarButtonItem) {
        
        // Reset edit
        isEditingPhotos = false
        
        setActions()
        displayEditStatus()
        
        // Delete selected photos
        
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        isEditingPhotos = false
        banner.image = UIImage(named: appDelegate.bannerImage)
        
        // Layout
        getGeoLocation()
        setActions()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Class Functions
    func getGeoLocation() {
        
        let location = CLLocation(latitude: (pin?.latitude)!, longitude: (pin?.longitude)!)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Guard if no location was returned
            guard (error == nil) else {
                fatalError("Could not find location: \(error)")
            }
            
            // Get location address
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let addressDictionary = placemark?.addressDictionary
                let addressArray = (addressDictionary?["FormattedAddressLines"] as? [String])!
                
                self.address = addressArray.joined(separator: ", ")
                self.hint.text = (self.address != "") ? self.address : "Unknown Location"
            }
        })
    }
    
    func setActions() {
        
        // Toggle user actions
        deletePhotos.isEnabled = isEditingPhotos
        addNewPhotos.isEnabled = !isEditingPhotos
    }
    
    func displayEditStatus() {
        
        // Set edit mode title and user action message
        if (isEditingPhotos) {
            photoAction.title = "CANCEL"
            hint.text = "Select Pictures to Delete"
        } else {
            photoAction.title = "EDIT"
            hint.text = (address != "") ? address : "Unknown Location"
        }
    }
}

// MARK: PhotoAlbumViewController+FetchedResultsControllerDelegate
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func fetchedResults() -> NSFetchedResultsController<NSFetchRequestResult> {
        
        // Fetch photos for the pin location
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "pin == %@", argumentArray: [pin!])
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
}

// MARK: PhotoAlbumViewController+CollectionViewDataSource+CollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        return cell
    }
}

