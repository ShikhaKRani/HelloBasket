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
        
        self.fetchHomeData()
    }
    
    
    func fetchHomeData() {
        
        var param: [String: Any] = [ : ]
        
        Loader.showHud()
        ServiceClient.getHomeListing(parameters: param) {[weak self] result in
            Loader.dismissHud()
            switch result {
            case let .success(response):
                if let notification = response.data {
                    
                    print(notification)
//                    self?.dataArr = notification
//                    self?.collectionView.reloadData()
//                    print(self?.dataArr?.collections as Any)
                    
                }
                
            case .failure: break
            }
        }
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
