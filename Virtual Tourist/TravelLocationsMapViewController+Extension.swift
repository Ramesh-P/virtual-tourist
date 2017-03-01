//
//  TravelLocationsMapViewController+Extension.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/1/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController+Extension
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
            fatalError("Could not fetch pins: \(error)")
        }
    }
    
    func loadLocationPins(from results: [Pin]) {
        
        // Add previously stored location pins to the map
        var annotations = [Annotation]()
        
        for pin in results {
            annotation = Annotation(pin: pin)
            annotations.append(annotation!)
        }
        
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
            
            // Download pictures for pin location
            
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
    
    // MARK: Map Region
    func fetchRegion() {
        
        // Fetch preset location and zoom level from data store
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Preset")
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try appDelegate.stack.context.fetch(fetchRequest)
            if let results = results as? [Preset] {
                if (results.count > 0) {
                    preset = results[0]
                }
            }
        } catch {
            fatalError("Could not fetch map presets: \(error)")
        }
        
        loadRegion()
    }
    
    func loadRegion() {
        
        if (preset != nil) {
            
            // Load preset map location and zoom level
            let latitude = (preset?.latitude)!
            let longitude = (preset?.longitude)!
            let latitudeDelta = (preset?.latitudeDelta)!
            let longitudeDelta = (preset?.longitudeDelta)!
            
            // Set map region by previous location and zoom level choice
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
            let region = MKCoordinateRegionMake(location, span)
            
            map.setRegion(region, animated: true)
        }
    }
    
    func setSpan() {
        
        // Set span to user selected zoom level
        let latitudeDelta = map.region.span.latitudeDelta
        let longitudeDelta = map.region.span.longitudeDelta
        
        setRegion(latitudeDelta, longitudeDelta)
    }
    
    func resetSpan() {
        
        // Reset span to default zoom level
        let latitudeDelta = appDelegate.latitudeDelta
        let longitudeDelta = appDelegate.longitudeDelta
        
        setRegion(latitudeDelta, longitudeDelta)
    }
    
    func setRegion(_ latitudeDelta: CLLocationDegrees, _ longitudeDelta: CLLocationDegrees) {
        
        // Set map to selected location
        let latitude = map.region.center.latitude
        let longitude = map.region.center.longitude
        
        // Set map region per location and zoom level choice
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        let region = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        saveRegion(region)
    }
    
    func saveRegion(_ region: MKCoordinateRegion) {
        
        // Save map region to user selected location and zoom level
        if (preset == nil) {
            preset = Preset(latitude: region.center.latitude, latitudeDelta: region.span.latitudeDelta, longitude: region.center.longitude, longitudeDelta: region.span.longitudeDelta, context: appDelegate.stack.context)
        } else {
            preset?.latitude = region.center.latitude
            preset?.latitudeDelta = region.span.latitudeDelta
            preset?.longitude = region.center.longitude
            preset?.longitudeDelta = region.span.longitudeDelta
        }
        
        appDelegate.stack.saveContext()
    }
}
