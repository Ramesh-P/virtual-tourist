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
    var selectedCells = [IndexPath]()
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
        resetSelectedCells()
    }
    
    @IBAction func addNewPhotoCollection(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func deleteSelectedPhotos(_ sender: UIBarButtonItem) {
        
        // Delete selected photos & reset album
        deleteSelectedPhotos()
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        isEditingPhotos = false
        banner.image = UIImage(named: appDelegate.bannerImage)
        fetchedResultsController?.delegate = self
        
        // Layout
        fetchPhotos()
        getGeoLocation()
        initializeLayout()
        setActions()
        displayEditStatus()
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
            
            if (photoCollection.count == 0) {
                hint.text = "All pictures are deleted. Add a new collection"
            } else {
                hint.text = (address != "") ? address : "Unknown Location"
            }
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
    
    func setSelected(_ cell: Cell, at indexPath: IndexPath) {
        
        // Not allowed to select photos if not in edit mode
        if (!isEditingPhotos) {
            return
        }
        
        // Set cell selection
        if let index = selectedCells.index(of: indexPath) {
            selectedCells.remove(at: index)
        } else {
            selectedCells.append(indexPath)
        }
        
        highlightSelected(cell, at: indexPath)
    }
    
    func resetSelectedCells() {
        
        // Not allowed to reset selection if in edit mode
        if (isEditingPhotos) {
            return
        }
        
        // Reset selected cells
        selectedCells.removeAll()
        album.reloadData()
    }
    
    func highlightSelected(_ cell: Cell, at indexPath: IndexPath) {
        
        // Toggle cell selection visualization
        if let _ = selectedCells.index(of: indexPath) {
            cell.alpha = 0.375
        } else {
            cell.alpha = 1.0
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
        
        return photoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! Cell
        let picture = fetchedResultsController?.object(at: indexPath) as! Photo
        
        // Display location image and title
        if (picture.image == nil) {
            
            /*
            cell.indicator.startAnimating()
            cell.thumbnail.image = UIImage(named: "Blank")
            cell.title.text = "Loading..."
 */
            
        } else {
            cell.thumbnail.image = UIImage(data: picture.image as! Data)
            cell.title.text = (picture.title != "") ? picture.title : "Untitled"
        }
        
        // Highlight selected cells
        highlightSelected(cell, at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Add or remove the highlighted cells to the list
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        
        setSelected(cell, at: indexPath)
    }
}

// MARK: PhotoAlbumViewController+Extension+Photos
extension PhotoAlbumViewController {
    
    // MARK: Photos
    func deleteSelectedPhotos() {
        
        var selectedPhotos = [Photo]()
        selectedCells = selectedCells.sorted(by: {$0.row > $1.row})
        
        // Delete selected photos and perform batch update
        album.performBatchUpdates({
            
            // Delete photos from album
            for indexPath in self.selectedCells {
                self.album.deleteItems(at: [indexPath])
                self.photoCollection.remove(at: indexPath.row)
            }
            
            // Delete photos from data store
            for indexPath in self.selectedCells {
                selectedPhotos.append(self.fetchedResultsController?.object(at: indexPath as IndexPath) as! Photo)
            }
            
            for photo in selectedPhotos {
                self.appDelegate.stack.context.delete(photo)
            }
            
            self.appDelegate.stack.saveContext()
        }) {(completion) in
            
            // Fetch remaining photos from the data store
            self.photoCollection.removeAll()
            self.fetchPhotos()
            
            // Reset
            self.isEditingPhotos = false
            
            self.setActions()
            self.displayEditStatus()
            self.resetSelectedCells()
        }
    }
}

