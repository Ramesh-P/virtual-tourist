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
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var insertIndexPath: [NSIndexPath]?
    var deleteIndexPath: [NSIndexPath]?
    var pin: Pin?
    var photoCollection = [Photo]()
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
        fetchedResultsController?.delegate = self
        
        // Layout
        getGeoLocation()
        setActions()
        initializeLayout()
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Layout
        album.reloadData()
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
    
    func initializeLayout() {
        
        // Layout cells
        let itemsPerRow: CGFloat = 3.0
        var size: CGFloat = 0.0
        let flowLayout = album.collectionViewLayout as? UICollectionViewFlowLayout
        
        size = UIScreen.main.bounds.size.width / itemsPerRow
        flowLayout?.itemSize = CGSize(width: size, height: size + 64)
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
    
    //func fetchPhotos() -> [Photo] {
    func fetchPhotos() {
        
        // Fetch location photos from data store
        fetchedResultsController = fetchedResults()
        
        do {
            try fetchedResultsController?.performFetch()
            if let results = fetchedResultsController?.fetchedObjects as? [Photo] {
                photoCollection = results
            }
        } catch {
            fatalError("Could not fetch photos: \(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Reset index
        insertIndexPath = [NSIndexPath]()
        deleteIndexPath = [NSIndexPath]()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Perform batch changes
        album.performBatchUpdates( {
            self.album.insertItems(at: self.insertIndexPath as! [IndexPath])
            self.album.deleteItems(at: self.deleteIndexPath as! [IndexPath])
        }, completion: nil)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            insertIndexPath?.append(newIndexPath! as NSIndexPath)
        case .delete:
            deleteIndexPath?.append(indexPath! as NSIndexPath)
        default:
            break
        }
    }
}

// MARK: PhotoAlbumViewController+CollectionViewDataSource+CollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 21
        
        /*
        if let fetchedResultsController = fetchedResultsController {
            return fetchedResultsController.sections![section].numberOfObjects
        } else {
            return 0
        }
 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! Cell
        let picture = fetchedResultsController?.object(at: indexPath) as! Photo
        
        if (picture.image == nil) {
            
        } else {
            cell.thumbnail.image = UIImage(data: picture.image as! Data)
            cell.title.text = picture.title
        }
        
        return cell
    }
}

// MARK: PhotoAlbumViewController+Extension+Photos
extension PhotoAlbumViewController {
    
    // MARK: Photos
    
}

