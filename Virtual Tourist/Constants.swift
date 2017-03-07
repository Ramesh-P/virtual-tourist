//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit

// MARK: Constants
struct Constants {
    
    // MARK: Screen Height
    struct ScreenHeight {
        static let phoneSE: CGFloat = 568.0
        static let phone: CGFloat = 667.0
        static let phonePlus: CGFloat = 736.0
    }
    
    // MARK: Font Size
    struct FontSize {
        struct BarButton {
            static let phoneSE: CGFloat = 10.2
            static let phone: CGFloat = 12.0
            static let phonePlus: CGFloat = 13.2
        }
        
        struct Label {
            static let phoneSE: CGFloat = 11.1
            static let phone: CGFloat = 13.0
            static let phonePlus: CGFloat = 14.4
        }
    }
    
    // MARK: Left Margin
    struct LeftMargin {
        static let phoneSE: CGFloat = -16.0
        static let phone: CGFloat = -10.0
        static let phonePlus: CGFloat = -10.0
    }
    
    // MARK: Map Overlay
    struct MapOverlay {
        static let openStreetMapCarto = "http://a.tile.openstreetmap.org/{z}/{x}/{y}.png"
        static let openStreetMapGrayscale = "https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png"
        static let cartoLightAll = "http://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"
        static let cartoLightNolabels = "http://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png"
        static let stamenToner = "http://a.tile.stamen.com/toner/{z}/{x}/{y}.png"
    }
    
    // MARK: Default Span
    struct DefaultSpan {
        struct LatitudeDelta {
            static let phoneSE: CLLocationDegrees = 59.0989451658838
            static let phone: CLLocationDegrees = 62.8194090540796
            static let phonePlus: CLLocationDegrees = 65.3578156691795
        }
        
        struct LongitudeDelta {
            static let phoneSE: CLLocationDegrees = 61.2760150000001
            static let phone: CLLocationDegrees = 61.276015
            static let phonePlus: CLLocationDegrees = 61.276015
        }
    }
}

