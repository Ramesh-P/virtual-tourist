//
//  Photo+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }
    
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
