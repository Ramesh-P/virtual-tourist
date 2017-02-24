//
//  AppNavigationControllerDelegate.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/23/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import Foundation
import UIKit

// MARK: AppNavigationControllerDelegate
class AppNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    // MARK: Properties
    var screenHeight: CGFloat = CGFloat()
    
    // MARK: Setup Title
    func setAppTitleImage(_ viewController: UIViewController) {
        
        // Get screen height
        screenHeight = UIScreen.main.bounds.size.height
        
        // Display app title
        switch screenHeight {
        case Constants.ScreenHeight.phonePlus, Constants.ScreenHeight.phone:
            viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "AppTitleImage-Portrait")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        case Constants.ScreenHeight.phoneSE:
            viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "AppTitleImage-568h-Portrait"), for: .default)
        default:
            break
        }
    }
}

