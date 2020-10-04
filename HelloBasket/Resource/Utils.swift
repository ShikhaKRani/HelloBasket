//
//  Utils.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import SideMenu

class Utils: NSObject {

    
    class func setupSideMenu(navigationController: UINavigationController,storyBoardName:String) -> Void {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: storyBoardName, bundle:nil)
        let leftVc = storyBoard.instantiateViewController(withIdentifier: "SideNavigationViewController") as! SideNavigationViewController
        let menuLeftNavigationController = SideMenuNavigationController(rootViewController:leftVc)
        SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
        menuLeftNavigationController.statusBarEndAlpha = 0
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: navigationController.view)
        
        
    }
    class  func updateMenus() {
        let settings = makeSettings()
        SideMenuManager.default.leftMenuNavigationController?.settings = settings

    }
    
    
    class func background(work: @escaping () -> ()) {
           DispatchQueue.global(qos: .userInitiated).async {
               work()
           }
       }
     
    
    func main(work: @escaping () -> ()) {
           DispatchQueue.main.async {
               work()
           }
       }
    
    
    class func makeSettings() -> SideMenuSettings {
        
        var set = SideMenuSettings()
        set.statusBarEndAlpha = 0
        set.presentationStyle = SideMenuPresentationStyle.menuSlideIn
        set.presentationStyle.presentingEndAlpha = 0.5
        set.menuWidth = (UIScreen.main.bounds.width)*2.5/3
        set.alwaysAnimate = true
        return set
    }
    
    
    
}

