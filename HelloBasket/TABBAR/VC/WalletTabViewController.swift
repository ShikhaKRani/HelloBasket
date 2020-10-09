//
//  WalletTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//

import UIKit

class WalletTabViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WalletTabViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    //MARK:- Side Menu Set up
}
