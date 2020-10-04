//
//  HomeViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import SideMenu


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
}

extension HomeViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.enableTapToDismissGesture = true
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    //MARK:- Side Menu Set up
}
