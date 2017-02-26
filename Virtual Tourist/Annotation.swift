//
//  Annotation.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import MapKit

// MARK: Annotation
class Annotation: NSObject, MKAnnotation {
    
    // MARK: Properties
    var locationCoordinate: CLLocationCoordinate2D
    var pin: Pin?
    var coordinate: CLLocationCoordinate2D {
        return locationCoordinate
    }
    
    // MARK: Initializers
    init(locationCoordinate: CLLocationCoordinate2D) {
        self.locationCoordinate = locationCoordinate
    }
    
    init(pin: Pin) {
        self.pin = pin
        self.locationCoordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }
    
    // MARK: Class Functions
    public func updateCoordinate(newLocationCoordinate: CLLocationCoordinate2D) -> Void {
        
        // Update location coordinate from old to new
        willChangeValue(forKey: "coordinate")
        locationCoordinate = newLocationCoordinate
        didChangeValue(forKey: "coordinate")
    }
}

