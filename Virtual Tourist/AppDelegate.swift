//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Ramesh Parthasarathy on 2/20/17.
//  Copyright © 2017 Ramesh Parthasarathy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bannerImage: String = String()
    
    // MARK: Application Delegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set status bar color
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Hide navigation bar border
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        // Hide toolbar border
        UIToolbar.appearance().clipsToBounds = true
        
        // Set UI object defaults
        setDefaults()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Application Functions
    func setDefaults() {
        
        // Get screen height
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Set UI object appearance
        var barButtonFontSize: CGFloat = CGFloat()
        var labelFontSize: CGFloat = CGFloat()
        
        switch screenHeight {
        case Constants.ScreenHeight.phonePlus:
            barButtonFontSize = 13.2
            labelFontSize = 14.4
            bannerImage = "BannerImage"
        case Constants.ScreenHeight.phone:
            barButtonFontSize = 12.0
            labelFontSize = 13.0
            bannerImage = "BannerImage"
        case Constants.ScreenHeight.phoneSE:
            barButtonFontSize = 10.2
            labelFontSize = 11.1
            bannerImage = "BannerImage-568h"
        default:
            break
        }
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: barButtonFontSize) as Any], for: .normal)
        UILabel.appearance().font = UIFont(name: "SFUIText-Semibold", size: labelFontSize)
    }
}

