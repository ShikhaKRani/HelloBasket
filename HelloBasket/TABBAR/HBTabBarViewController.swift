//
//  HBTabBarViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//


import UIKit

class HBTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var tabSelectedIndex = 0
    let unselectedColor = UIColor.white
    let selectedColor = AppColor.themeColorSecond
    let selectedTitle = UIColor.black

    
    
    //fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = true
        //self.tabBarController?.selectedIndex = tabSelectedIndex
        self.tabBar.isTranslucent = true
        self.tabBar.itemPositioning =  UITabBar.ItemPositioning.fill
        self.delegate = self
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = AppColor.themeColor
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .regular), NSAttributedString.Key.foregroundColor: unselectedColor]
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.orange]
        
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor        
        tabBar.standardAppearance = appearance
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //      self.setTabbarSeperator()
        // safe place to set the frame of button manually
        
        
    }
    
    
    
    //    override func viewWillLayoutSubviews() {
    //            super.viewWillLayoutSubviews()
    //
    //            let newTabBarHeight = defaultTabBarHeight + 16.0
    //
    //            var newFrame = tabBar.frame
    //            newFrame.size.height = newTabBarHeight
    //            newFrame.origin.y = view.frame.size.height - newTabBarHeight
    //
    //            tabBar.frame = newFrame
    //        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    //        return .portrait
    //    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    func setTabbarSeperator() -> Void {
        if let items = self.tabBar.items {
            let height = self.tabBar.bounds.height
            //Calculate the size of the items
            
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
            for index in 0..<items.count {
                let xPosition = itemSize.width * CGFloat(index)
                let separator = UIView(frame: CGRect(
                                        x: xPosition, y: 5, width: 0.5, height: 50))
                separator.backgroundColor = UIColor.white
                tabBar.insertSubview(separator, at: 1)
                
            }
        }
        
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //        if viewController is HomePageViewController {
        //            viewController.navigationController?.isNavigationBarHidden = true
        //        } else if viewController is AnalyticsViewController {
        //            viewController.navigationController?.isNavigationBarHidden = false
        //            viewController.navigationController?.navigationBar.prefersLargeTitles = true
        //            viewController.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        //        } else if viewController is GallaryTabViewController {
        //           // viewController.navigationController?.navigationItem.title = "Gallary"
        //            viewController.navigationController?.isNavigationBarHidden = false
        //            viewController.navigationController?.navigationBar.prefersLargeTitles = true
        //            viewController.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        //        }else{
        //            //viewController.navigationController?.navigationItem.title = "FAQs"
        //            viewController.navigationController?.isNavigationBarHidden = false
        //            viewController.navigationController?.navigationBar.prefersLargeTitles = true
        //            viewController.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        //        }
    }
    
    
}

extension HBTabBarViewController {
    
   
    
}

