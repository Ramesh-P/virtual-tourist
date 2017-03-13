//
//  TravelLocationsMapViewController+Pins.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/1/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController+Extension+Pins
extension TravelLocationsMapViewController {
    
    // MARK: Location Pins
    func fetchPins() {
        
        // Fetch location pins from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Pin] {
                if (results.count > 0) {
                    if (canLoadPins) {
                        
                        // Add previously stored location pins to the map
                        loadLocationPins(from: results)
                    } else if (canDeletePins) {
                        
                        // Delete all pins from map and data store
                        deleteAllPins(in: results)
                    }
                } else {
                    resetEdit()
                }
            }
        } catch {
            displayError("Could not fetch pins")
        }
    }
    
    func loadLocationPins(from results: [Pin]) {
        
        // Add previously stored location pins to the map
        var annotations = [Annotation]()
        
        for pin in results {
            annotation = Annotation(pin: pin)
            annotations.append(annotation!)
        }
        
        map.removeAnnotations(annotations)
        map.addAnnotations(annotations)
    }
    
    @objc func addLocationPin(uponGestureReconizer whereTouched: UILongPressGestureRecognizer) {
        
        // Not allowed to add pins in edit mode
        if (isEditingPins) {
            return
        }
        
        // Add location pin
        let location = whereTouched.location(in: map)
        let coordinate = map.convert(location, toCoordinateFrom: map)
        
        if (whereTouched.state == .began) {
            
            // Place location pin in the map where touched
            annotation = Annotation(locationCoordinate: coordinate)
            map.addAnnotation(annotation!)
        } else if (whereTouched.state == .changed) {
            
            // Continue to move pin to a new location as desired
            annotation?.updateCoordinate(newLocationCoordinate: coordinate)
        } else if (whereTouched.state == .ended) {
            
            // Save location pin to data store
            pin = Pin(latitude: (annotation?.locationCoordinate.latitude)!, longitude: (annotation?.locationCoordinate.longitude)!, context: appDelegate.stack.context)
            appDelegate.stack.saveContext()
            
            // Download photos for pin location
            searchPhotosFor(pin!)
        }
    }
    
    func deleteAllPins(in results: [Pin]) {
        
        // Delete all pins from map and data store
        for pin in results {
            appDelegate.stack.context.delete(pin)
        }
        
        appDelegate.stack.saveContext()
        map.removeAnnotations(map.annotations)
        
        resetEdit()
    }
}

