//
//  TravelLocationsMapViewController.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/20/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

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
        
        // Verify available fonts
        /*
        for family: String in UIFont.familyNames {
            print("\(family)")
            
            for names: String in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
 */
}

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

