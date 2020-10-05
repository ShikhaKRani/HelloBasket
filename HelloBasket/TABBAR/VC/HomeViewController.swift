//
//  HomeViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import SideMenu


class HomeViewController: UIViewController {

    
    @IBOutlet weak var navigationView: UIView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor
    }
   
    
}

extension HomeViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    //MARK:- Side Menu Set up
}
