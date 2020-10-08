//
//  AppDelegate.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
     var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
//        after login
       // Utils.redirectToHome()
        return true
    }

    
    
    //----
    public func loadAndSetupabBar() {
        let storyboard = UIStoryboard(name: "TabbarMenu", bundle: nil)
        if let mainViewController = storyboard.instantiateViewController(withIdentifier: "HBTabBarViewController") as? HBTabBarViewController {
            mainViewController.automaticallyAdjustsScrollViewInsets = true
            let nav = UINavigationController.init(rootViewController: mainViewController)
            self.window?.rootViewController = nav
        }
    }
    

    
    
    

}

