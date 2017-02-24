//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/20/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

/**
 * Credits/Attributions:
 * Map tiles are property of OpenStreetMap Foundation and their contributors.
 *
 * OpenStreetMap Attribution
 * -------------------------
 * OpenStreetMap® is open data, licensed under the Open Data Commons Open Database License (ODbL) by the OpenStreetMap Foundation (OSMF).
 * https://www.openstreetmap.org/copyright
 *
 * CARTO Attribution
 * -----------------
 * https://carto.com/attribution
 *
 * Stamen Attribution
 * ------------------
 * Except otherwise noted, each of these map tile sets are © Stamen Design, under a Creative Commons Attribution (CC BY 3.0) license.
 * http://maps.stamen.com/#terrain/12/37.7706/-122.3782
 *
 * For Toner and Terrain: Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL.
 * Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href=“http://www.openstreetmap.org/copyright">ODbL</a>.
 *
 * For Watercolor: Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under CC BY SA.
 * Map tiles by <a href="http://stamen.com">Stamen Design</a>, under <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a href="http://openstreetmap.org">OpenStreetMap</a>, under <a href="http://creativecommons.org/licenses/by-sa/3.0">CC BY SA</a>.
 *
 */

import Foundation
import UIKit
import MapKit

// MARK: TravelLocationsMapViewController
class TravelLocationsMapViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let navigationControllerDelegate = AppNavigationControllerDelegate()
    
    // MARK: Outlets
    @IBOutlet weak var travelLocations: MKMapView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var pinAction: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func deletePin(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func resetMapSize(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func deleteAllPins(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        navigationControllerDelegate.setAppTitleImage(self)
        banner.image = UIImage(named: appDelegate.bannerImage)
        setMapTileOverlay()
}

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Class Functions
    func setMapTileOverlay() {
        
        // Add overlay tiles to map view
        let template = Constants.MapOverlay.cartoLightAll
        let overlay = MKTileOverlay(urlTemplate: template)
        
        overlay.canReplaceMapContent = true
        travelLocations.add(overlay, level: .aboveLabels)
        travelLocations.delegate = self
    }
}

// MARK: TravelLocationsMapViewController+MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Render overlay tiles on the map view
        guard let tileOverlay = overlay as? MKTileOverlay else {
            return MKOverlayRenderer()
        }
        
        return MKTileOverlayRenderer(tileOverlay: tileOverlay)
    }
}

