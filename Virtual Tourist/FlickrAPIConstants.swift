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
        static let sort = "sort"
        static let boundingBox = "bbox"
        static let search = "safe_search"
        static let contentType = "content_type"
        static let media = "media"
        static let extras = "extras"
        static let photosPerPage = "per_page"
        static let format = "format"
        static let noJSONCallback = "nojsoncallback"
    }
    
    // MARK: Flickr Parameter Values
    struct ParameterValues {
        static let photosSearch = "flickr.photos.search"
        static let apiKey = "6ebf6fc89a59ca7d25b46f895d25ab0e"
        static let datePostedAsc = "date-posted-asc"
        static let datePostedDesc = "date-posted-desc"
        static let dateTakenAsc = "date-taken-asc"
        static let dateTakenDesc = "date-taken-desc"
        static let interestingnessDesc = "interestingness-desc"
        static let interestingnessAsc = "interestingness-asc"
        static let relevance = "relevance"
        static let useSafeSearch = "1"
        static let photosOnly = "1"
        static let photos = "photos"
        static let mediumURL = "url_m"
        static let photosLimit = "21"
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
    }
    
    // MARK: Flickr Response Values
    struct ResponseValues {
        static let ok = "ok"
    }
}

