//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: Constants
struct Constants {
    
    // MARK: Screen Height
    struct ScreenHeight {
        static let phoneSE: CGFloat = 568.0
        static let phone: CGFloat = 667.0
        static let phonePlus: CGFloat = 736.0
    }
    
    // MARK: Map Overlay
    struct MapOverlay {
        static let openStreetMapCarto = "http://a.tile.openstreetmap.org/{z}/{x}/{y}.png"
        static let openStreetMapGrayscale = "https://tiles.wmflabs.org/bw-mapnik/{z}/{x}/{y}.png"
        static let cartoLightAll = "http://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"
        static let cartoLightNolabels = "http://a.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png"
        static let stamenToner = "http://a.tile.stamen.com/toner/{z}/{x}/{y}.png"
    }
}

