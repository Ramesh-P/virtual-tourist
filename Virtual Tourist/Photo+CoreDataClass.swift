//
//  Photo+CoreDataClass.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData

// MARK: Photo
public class Photo: NSManagedObject {
    
    // MARK: Initializers
    convenience init(image: NSData, title: String, url: String, context: NSManagedObjectContext) {
        
        // Create entity description for Photo
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: entity, insertInto: context)
            
            self.image = image
            self.title = title
            self.url = url
        } else {
            fatalError("Unable to find Photo entity")
        }
    }
}

