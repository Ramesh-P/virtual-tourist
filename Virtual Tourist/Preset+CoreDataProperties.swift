//
//  Preset+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData


extension Preset {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Preset> {
        return NSFetchRequest<Preset>(entityName: "Preset");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var latitudeDelta: Double
    @NSManaged public var longitude: Double
    @NSManaged public var longitudeDelta: Double

}
