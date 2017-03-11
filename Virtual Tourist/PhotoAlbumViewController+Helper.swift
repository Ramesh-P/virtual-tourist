//
//  PhotoAlbumViewController+Helper.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/11/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: PhotoAlbumViewController+Extension+Helper
extension PhotoAlbumViewController {
    
    // MARK: Class Functions
    func getGeoLocation() {
        
        let location = CLLocation(latitude: (pin?.latitude)!, longitude: (pin?.longitude)!)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Guard if no location was returned
            guard (error == nil) else {
                fatalError("Could not find location: \(error)")
            }
            
            // Get location address
            if (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let addressDictionary = placemark?.addressDictionary
                let addressArray = (addressDictionary?["FormattedAddressLines"] as? [String])!
                
                self.address = addressArray.joined(separator: ", ")
                self.hint.text = (self.address != "") ? self.address : "Unknown Location"
            }
        })
    }
    
    func setSelected(_ cell: Cell, at indexPath: IndexPath) {
        
        // Not allowed to select photos if not in edit mode
        if (!isEditingPhotos) {
            return
        }
        
        // Set cell selection
        if let index = selectedCells.index(of: indexPath) {
            selectedCells.remove(at: index)
        } else {
            selectedCells.append(indexPath)
        }
        
        highlightSelected(cell, at: indexPath)
    }
    
    func resetSelectedCells() {
        
        // Not allowed to reset selection if in edit mode
        if (isEditingPhotos) {
            return
        }
        
        // Reset selected cells
        selectedCells.removeAll()
        album.reloadData()
    }
    
    func highlightSelected(_ cell: Cell, at indexPath: IndexPath) {
        
        // Toggle cell selection visualization
        if let _ = selectedCells.index(of: indexPath) {
            cell.alpha = 0.375
        } else {
            cell.alpha = 1.0
        }
    }
    
    // MARK: Class Helpers
    func initializeLayout() {
        
        // Layout cells
        let itemsPerRow: CGFloat = 3.0
        var size: CGFloat = 0.0
        let flowLayout = album.collectionViewLayout as? UICollectionViewFlowLayout
        
        size = UIScreen.main.bounds.size.width / itemsPerRow
        flowLayout?.itemSize = CGSize(width: size, height: size + 64)
    }
    
    func setActions() {
        
        // Toggle user actions
        deletePhotos.isEnabled = isEditingPhotos
        addNewPhotos.isEnabled = !isEditingPhotos
    }
    
    func displayEditStatus() {
        
        // Set edit mode title and user action message
        if (isEditingPhotos) {
            photoAction.title = "CANCEL"
            hint.text = "Select Pictures to Delete"
        } else {
            photoAction.title = "EDIT"
            
            if (photoCollection.count == 0) {
                hint.text = "All pictures are deleted. Add a new collection"
            } else {
                hint.text = (address != "") ? address : "Unknown Location"
            }
        }
    }
}

