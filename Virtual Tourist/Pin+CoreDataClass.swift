//
//  Pin+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData

// MARK: Pin
public class Pin: NSManagedObject {
    
    // MARK: Initializers
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        // Create entity description for Pin
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find Pin entity")
        }
    }
}

