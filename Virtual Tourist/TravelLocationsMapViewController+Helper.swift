//
//  TravelLocationsMapViewController+Helper.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/11/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: TravelLocationsMapViewController+Extension+Helper

extension TravelLocationsMapViewController {
    
    // MARK: Class Functions
    func setMapTileOverlay() {
        
        // Add overlay tiles to map view
        let template = Constants.MapOverlay.cartoLightAll
        let overlay = MKTileOverlay(urlTemplate: template)
        
        overlay.canReplaceMapContent = true
        map.add(overlay, level: .aboveLabels)
        map.delegate = self
    }
    
    func addGestureReconizer() {
        
        // Add tap and hold gesture to map view
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.addLocationPin(uponGestureReconizer:)))
        map.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: Class Helpers
    func resetEdit() {
        
        // Reset actions
        canLoadPins = true
        canDeletePins = false
        isEditingPins = false
        
        displayEditStatus()
    }
    
    func displayEditStatus() {
        
        // Set edit mode title and user action message
        if (isEditingPins) {
            pinAction.title = "DONE"
            hint.text = "Tap a Pin to Remove"
        } else {
            pinAction.title = "EDIT"
            hint.text = "Tap and Hold to Drop Pin . Tap Pin to Add Photos"
        }
    }
}

