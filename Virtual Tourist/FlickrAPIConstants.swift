//
//  FlickrAPIConstants.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/2/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation

// MARK: FlickrAPIConstants
struct Flickr {
    
    // MARK: URLs
    struct Constants {
        static let apiScheme = "https"
        static let apiHost = "api.flickr.com"
        static let apiPath = "/services/rest"
    }
    
    // MARK: Bounding Box
    struct BoundingBox {
        static let halfWidth = 1.0
        static let halfHeight = 1.0
        static let latitudeRange = (-90.0, 90.0)
        static let longitudeRange = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct ParameterKeys {
        static let method = "method"
        static let apiKey = "api_key"
        static let boundingBox = "bbox"
        static let search = "safe_search"
        static let extras = "extras"
        static let page = "page"
        static let format = "format"
        static let noJSONCallback = "nojsoncallback"
    }
    
    // MARK: Flickr Parameter Values
    struct ParameterValues {
        static let photosSearch = "flickr.photos.search"
        static let apiKey = "6ebf6fc89a59ca7d25b46f895d25ab0e"
        static let useSafeSearch = "1"
        static let mediumURL = "url_m"
        static let jsonFormat = "json"
        static let disableJSONCallback = "1"
    }
    
    // MARK: Flickr Response Keys
    struct ResponseKeys {
        static let status = "stat"
        static let photos = "photos"
        static let photo = "photo"
        static let title = "title"
        static let mediumURL = "url_m"
        static let pages = "pages"
        static let total = "total"
    }
    
    // MARK: Flickr Response Values
    struct ResponseValues {
        static let ok = "ok"
    }
}

