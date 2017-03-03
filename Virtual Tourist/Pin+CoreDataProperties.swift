//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/25/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Pin {

    @objc(insertObject:inPhotosAtIndex:)
    @NSManaged public func insertIntoPhotos(_ value: Photo, at idx: Int)

    @objc(removeObjectFromPhotosAtIndex:)
    @NSManaged public func removeFromPhotos(at idx: Int)

    @objc(insertPhotos:atIndexes:)
    @NSManaged public func insertIntoPhotos(_ values: [Photo], at indexes: NSIndexSet)

    @objc(removePhotosAtIndexes:)
    @NSManaged public func removeFromPhotos(at indexes: NSIndexSet)

    @objc(replaceObjectInPhotosAtIndex:withObject:)
    @NSManaged public func replacePhotos(at idx: Int, with value: Photo)

    @objc(replacePhotosAtIndexes:withPhotos:)
    @NSManaged public func replacePhotos(at indexes: NSIndexSet, with values: [Photo])

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
