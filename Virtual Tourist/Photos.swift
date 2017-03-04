//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/4/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation

// MARK: Photos
struct Photos {
    
    // MARK: Properties
    let title: String
    let url: String
    
    // MARK: Initializer
    init(dictionary: [String:AnyObject]) {
        
        if let stringTitle = dictionary[Flickr.ResponseKeys.title] as? String {
            title = stringTitle
        } else {
            title = "Untitled"
        }
        
        if let stringURL = dictionary[Flickr.ResponseKeys.mediumURL] as? String {
            url = stringURL
        } else {
            url = String()
        }
    }
    
    static func addToCollectionFrom(_ results: [[String:AnyObject]]) -> [Photos] {
        
        var photoCollection = [Photos]()
        
        // Iterate through the photo array and add each photo url and title to a dictionary
        for result in results {
            photoCollection.append(Photos(dictionary: result))
        }
        
        return photoCollection
    }
}

