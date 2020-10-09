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
        //For now
        UserDetails.shared.setAccessToken(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9udGl2ZS5sb2NhbFwvYXBpXC9sb2dpbiIsImlhdCI6MTU5ODk0NzU3NSwibmJmIjoxNTk4OTQ3NTc1LCJqdGkiOiJEVXJjV0F2OWJuNkFjc0FGIiwic3ViIjo2LCJwcnYiOiIxZDBhMDIwYWNmNWM0YjZjNDk3OTg5ZGYxYWJmMGZiZDRlOGM4ZDYzIn0.DxL1bizqT2PYn6_WhWf5f18Z6pBPDDy4NVFVF54ZNCQ")
        
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

