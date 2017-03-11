//
//  PhotoAlbumViewController+Photos.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/11/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

// MARK: PhotoAlbumViewController+Extension+Photos
extension PhotoAlbumViewController {
    
    // MARK: Photos
    func deleteSelectedPhotos() {
        
        var selectedPhotos = [Photo]()
        selectedCells = selectedCells.sorted(by: {$0.row > $1.row})
        
        // Delete selected photos and perform batch update
        album.performBatchUpdates({
            
            // Delete photos from album
            for indexPath in self.selectedCells {
                self.album.deleteItems(at: [indexPath])
                self.photoCollection.remove(at: indexPath.row)
            }
            
            // Delete photos from data store
            for indexPath in self.selectedCells {
                selectedPhotos.append(self.fetchedResultsController?.object(at: indexPath as IndexPath) as! Photo)
            }
            
            performUIUpdatesOnMain {
                for photo in selectedPhotos {
                    self.appDelegate.stack.context.delete(photo)
                }
                
                self.appDelegate.stack.saveContext()
            }
        }) {(completion) in
            
            // Fetch remaining photos from the data store
            self.photoCollection.removeAll()
            self.fetchPhotos()
            
            // Reset
            self.isEditingPhotos = false
            
            self.setActions()
            self.displayEditStatus()
            self.resetSelectedCells()
        }
    }
}

