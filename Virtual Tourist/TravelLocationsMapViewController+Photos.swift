//
//  TravelLocationsMapViewController+Photos.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/7/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController+Extension+Photos
extension TravelLocationsMapViewController {
    
    // MARK: Photos
    func searchPhotosFor(_ pin: Pin) {
        
        let latitude = pin.latitude
        let longitude = pin.longitude
        let photosLimit = Flickr.ParameterValues.photosLimit
        
        // Searech Flickr for photos at pin location
        FlickrAPIMethods.sharedInstance().searchPhotoURLsForPinAt(latitude, longitude, photosLimit) { (success, error, result) in
            
            // Save urls
            performUIUpdatesOnMain {
                if success {
                    self.savePhotoURLsFor(pin, from: result!)
                } else {
                    self.displayError("Error downloading photos")
                }
            }
        }
    }
    
    func savePhotoURLsFor(_ pin: Pin, from photos: [Photos]) {
        
        // Save photo urls and title for pin
        for photoContents in photos {
            if (try? photoContents.url) != nil {
                let image: NSData? = NSData()
                let photo = Photo(image: image!, title: photoContents.title, url: photoContents.url, context: appDelegate.stack.context)
                photo.pin = pin
            }
        }
        
        appDelegate.stack.saveContext()
        savePhotoImageDataFor(pin)
    }
    
    func savePhotoImageDataFor(_ pin: Pin) {
        
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
            displayError("Could not fetch photos")
        }
    }
}

