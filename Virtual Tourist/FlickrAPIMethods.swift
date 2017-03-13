//
//  FlickrAPIMethods.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/2/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation

// MARK: FlickrAPIMethods
class FlickrAPIMethods: NSObject {
    
    // MARK: Properties
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> FlickrAPIMethods {
        
        struct Singleton {
            static var sharedInstance = FlickrAPIMethods()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Tasks
    func taskForGETMethod(_ request: NSMutableURLRequest, completionHandlerForGET: @escaping (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) -> URLSessionDataTask {
    
        // Step-3, 4: Configure and make the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForGET(false, "There was an error with your request", nil)
                return
            }
            
            // Guard if response is not in success range
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForGET(false, "Your request returned a status code other than 2xx", nil)
                return
            }
            
            // Guard if no data was returned
            guard let data = data else {
                completionHandlerForGET(false, "No data was returned by the request", nil)
                return
            }
            
            // Step-5, 6: Parse and use the data
            self.parseData(data, completionHandlerForParsedData: completionHandlerForGET)
        }
        
        // Step-7: Start the request
        task.resume()
        
        return task
    }
    
    // MARK: API Methods
    func searchPhotoURLsForPinAt(_ latitude: Double, _ longitude: Double, _ photosLimit: String, completionHandlerForPhotoSearch: @escaping (_ success: Bool, _ error: String?, _ result: [Photos]?) -> Void) {
        
        /**
         * Design Considerations:
         *
         * Flickr API currently do not support random sort.
         * In order to get random images on each search, the app has to make two calls to the server
         *
         * The first call is to get the total number of images available for the current search criteria
         * And the second call is to a random page based on the above total number of images
         * This approach is inefficient
         *
         * An alternative way is to pick a random option each time from a list of all available sort options
         * This will avoid two calls to the server
         *
         */
        
        let sortOptions = [
            Flickr.ParameterValues.datePostedAsc,
            Flickr.ParameterValues.datePostedDesc,
            Flickr.ParameterValues.dateTakenAsc,
            Flickr.ParameterValues.dateTakenDesc,
            Flickr.ParameterValues.interestingnessDesc,
            Flickr.ParameterValues.interestingnessAsc,
            Flickr.ParameterValues.relevance
        ]
        let index = Int(arc4random_uniform(UInt32(sortOptions.count)))
        let sortOption = sortOptions[index]
        
        // Step-1: Set the parameters
        let parameters: [String:String] = [
            Flickr.ParameterKeys.method: Flickr.ParameterValues.photosSearch,
            Flickr.ParameterKeys.apiKey: Flickr.ParameterValues.apiKey,
            Flickr.ParameterKeys.sort: sortOption,
            Flickr.ParameterKeys.boundingBox: boundingBox(latitude, longitude),
            Flickr.ParameterKeys.search: Flickr.ParameterValues.useSafeSearch,
            Flickr.ParameterKeys.contentType: Flickr.ParameterValues.photosOnly,
            Flickr.ParameterKeys.media: Flickr.ParameterValues.photos,
            Flickr.ParameterKeys.extras: Flickr.ParameterValues.mediumURL,
            Flickr.ParameterKeys.photosPerPage: photosLimit,
            Flickr.ParameterKeys.format: Flickr.ParameterValues.jsonFormat,
            Flickr.ParameterKeys.noJSONCallback: Flickr.ParameterValues.disableJSONCallback
        ]
        
        // Step-2: Build the URL
        let request = NSMutableURLRequest(url: urlFrom(parameters))
        
        // Make the request
        let _ = taskForGETMethod(request) { (success, error, result) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForPhotoSearch(false, error, nil)
                return
            }
            
            // Guard if not result status is ok
            guard let status = result?[Flickr.ResponseKeys.status] as? String, status == Flickr.ResponseValues.ok else {
                completionHandlerForPhotoSearch(false, "Photo search failed", nil)
                return
            }
            
            // Guard if photos key is not in the result
            guard let photosDictionary = result?[Flickr.ResponseKeys.photos] as? [String:AnyObject] else {
                completionHandlerForPhotoSearch(false, "Could not find photos key in the result", nil)
                return
            }
            
            // Guard if photo key is not in the result
            guard let photosArray = photosDictionary[Flickr.ResponseKeys.photo] as? [[String: AnyObject]] else {
                completionHandlerForPhotoSearch(false, "Could not find photo key in the result", nil)
                return
            }
            
            // Get URL and title from the result
            if success {
                if (photosArray.count > 0) {
                    let photoCollection = Photos.addToCollectionFrom(photosArray)
                    completionHandlerForPhotoSearch(true, nil, photoCollection)
                } else {
                    completionHandlerForPhotoSearch(false, "No photos Found on this Location", nil)
                }
            } else {
                completionHandlerForPhotoSearch(false, "Error downloading photos", nil)
            }
        }
    }
    
    // MARK: Convenience Functions
    func getPhotoImageDataFrom(_ url: String, completionHandlerForImageData: @escaping (_ success: Bool, _ error: String?, _ data: NSData?) -> Void) {
        
        let url = NSURL(string: url)
        let request = URLRequest(url: url! as URL)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Guard if there was an error
            guard (error == nil) else {
                completionHandlerForImageData(false, "There was an error with your request", nil)
                return
            }
            
            // Guard if response is not in success range
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForImageData(false, "Your request returned a status code other than 2xx", nil)
                return
            }
            
            // Guard if no data was returned
            guard let data = data else {
                completionHandlerForImageData(false, "No data was returned by the request", nil)
                return
            }
            
            completionHandlerForImageData(true, nil, data as NSData?)
        }
        
        task.resume()
    }    
}

// MARK: - FlickrAPIMethods+Extension
private extension FlickrAPIMethods {
    
    // MARK: Helper Functions
    func boundingBox(_ latitude: Double, _ longitude: Double) -> String {
        
        // Create bounding box within the acceptable range
        let minimumLongitude = max(longitude - Flickr.BoundingBox.halfWidth, Flickr.BoundingBox.longitudeRange.0)
        let minimumLatitude = max(latitude - Flickr.BoundingBox.halfHeight, Flickr.BoundingBox.latitudeRange.0)
        let maximumLongitude = min(longitude + Flickr.BoundingBox.halfWidth, Flickr.BoundingBox.longitudeRange.1)
        let maximumLatitude = min(latitude + Flickr.BoundingBox.halfHeight, Flickr.BoundingBox.latitudeRange.1)
        return "\(minimumLongitude),\(minimumLatitude),\(maximumLongitude),\(maximumLatitude)"
    }
    
    func urlFrom(_ parameters: [String:String]) -> URL {
        
        // Create an URL from parameters with path extension
        var components = URLComponents()
        components.scheme = Flickr.Constants.apiScheme
        components.host = Flickr.Constants.apiHost
        components.path = Flickr.Constants.apiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func parseData(_ data: Data, completionHandlerForParsedData: (_ success: Bool, _ error: String?, _ result: AnyObject?) -> Void) {
        
        //Parse the data
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForParsedData(false, "Could not parse the data as JSON", nil)
            return
        }
        
        // Use parsed data
        completionHandlerForParsedData(true, nil, parsedResult)
    }
}

