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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Get new or display existing photos for the location
        if (photoCollection.count == 0) {
            
            print("download images...")
            
        } else {
            album.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
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
        if (picture.image != nil) {
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

