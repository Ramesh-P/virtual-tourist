//
//  TravelLocationsMapViewController+Region.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/7/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController+Extension+Region
extension TravelLocationsMapViewController {
    
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

