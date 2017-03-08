//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 3/5/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    
    // MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pin: Pin?
    
    // MARK: Outlets
    @IBOutlet weak var album: UICollectionView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var photoAction: UIBarButtonItem!
    @IBOutlet weak var addNewPhotos: UIBarButtonItem!
    @IBOutlet weak var deletePhotos: UIBarButtonItem!
    
    // MARK: Actions
    @IBAction func editPhotos(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addNewPhotoCollection(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func deleteSelectedPhotos(_ sender: UIBarButtonItem) {
        
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Initialize
        banner.image = UIImage(named: appDelegate.bannerImage)
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

