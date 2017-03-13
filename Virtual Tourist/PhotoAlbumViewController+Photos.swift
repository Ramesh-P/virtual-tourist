//
//  PhotoAlbumViewController+Photos.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/11/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: PhotoAlbumViewController+Extension+Photos
extension PhotoAlbumViewController {
    
    // MARK: Photos
    func downloadPhotosFor(_ pin: Pin) {
        
        // Chain completion handlers for each request so that they run one after the other
        self.searchPhotosFor(pin) { (success, error, result) in
            if success {
                
                // Success: save urls
                self.savePhotoURLsFor(pin, from: result!) { (success) in
                    if success {
                        
                        // Success: save image data
                        self.savePhotoImageDataFor(pin) { (success, error) in
                            if success {
                                
                                // Success: display photos
                                self.displaySelectedPhotos {(completion) in
                                    
                                    // Success: reset user interface
                                    self.resetAfterDownloadingPhotos()
                                }
                            } else {
                                //completionHandlerForPhotoDownload(false, error)
                            }
                        }
                    } else {
                        //completionHandlerForPhotoDownload(false, error)
                    }
                }
            } else {
                //completionHandlerForPhotoDownload(false, error)
            }
        }
    }
    
    func searchPhotosFor(_ pin: Pin, completionHandlerForPhotoSearch: @escaping (_ success: Bool, _ error: String?, _ result: [Photos]?) -> Void) {
        
        let latitude = pin.latitude
        let longitude = pin.longitude
        let photosLimit = Flickr.ParameterValues.photosLimit
        
        // Searech Flickr for photos at pin location
        FlickrAPIMethods.sharedInstance().searchPhotoURLsForPinAt(latitude, longitude, photosLimit) { (success, error, result) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForPhotoSearch(false, error, nil)
                return
            }
            
            // Save urls
            performUIUpdatesOnMain {
                if success {
                    completionHandlerForPhotoSearch(true, nil, result)
                } else {
                    completionHandlerForPhotoSearch(false, error, nil)
                }
            }
        }
    }
    
    func savePhotoURLsFor(_ pin: Pin, from photos: [Photos], completionHandlerForPhotoURL: @escaping (_ success: Bool) -> Void) {
        
        // Save photo urls and title for pin
        for photoContents in photos {
            if (try? photoContents.url) != nil {
                let image: NSData? = NSData()
                let photo = Photo(image: image!, title: photoContents.title, url: photoContents.url, context: appDelegate.stack.context)
                photo.pin = pin
            }
        }
        
        appDelegate.stack.saveContext()
        completionHandlerForPhotoURL(true)
    }
    
    func savePhotoImageDataFor(_ pin: Pin, completionHandlerForPhotoImageData: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        // Fetch photo urls for pin from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", argumentArray: [pin])
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Photo] {
                if (results.count > 0) {
                    for result in results {
                        let url = result.url!
                        
                        // Get photo image data from Flickr
                        FlickrAPIMethods.sharedInstance().getPhotoImageDataFrom(url) { (success, error, data) in
                            
                            // Guard if there was an error
                            guard (error == nil) else {
                                completionHandlerForPhotoImageData(false, error)
                                return
                            }
                            
                            // Save image data
                            performUIUpdatesOnMain {
                                if success {
                                    result.image = data
                                    self.appDelegate.stack.saveContext()
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            completionHandlerForPhotoImageData(false, "Could not fetch photos: \(error)")
        }
        
        completionHandlerForPhotoImageData(true, nil)
    }

    func displaySelectedPhotos(completion: @escaping (_ success: Bool) -> Void) {
        
        self.isLoadingPhotos = false
        self.fetchPhotos()
        
        // Display new set of photos for the pin location
        if (self.photoCollection.count > 0) {
            let delay = DispatchTime.now() + .seconds(2)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                completion(true)
            }
        }
    }
    
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
            
            performUIUpdatesOnMain {
                for photo in selectedPhotos {
                    self.appDelegate.stack.context.delete(photo)
                }
                
                self.appDelegate.stack.saveContext()
            }
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
    
    func deleteAllPhotos() {
        
        // Delete all photos for the pin from data store
        for photo in photoCollection {
            appDelegate.stack.context.delete(photo)
        }

        appDelegate.stack.saveContext()
        
        // Reset
        photoCollection.removeAll()
    }
}

