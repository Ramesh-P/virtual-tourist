//
//  Preset+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData

// MARK: Preset
public class Preset: NSManagedObject {
    
    // MARK: Initializers
    convenience init(latitude: Double, latitudeDelta: Double, longitude: Double, longitudeDelta: Double, context: NSManagedObjectContext) {
        
        // Create entity description for Preset
        if let entity = NSEntityDescription.entity(forEntityName: "Preset", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.latitude = latitude
            self.latitudeDelta = latitude
            self.longitude = longitude
            self.longitudeDelta = longitudeDelta
        } else {
            fatalError("Unable to find Preset entity")
        }
    }
}

