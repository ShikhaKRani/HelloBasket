//
//  LoginViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nextbutton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white


        self.nextbutton.addTarget(self, action: #selector(redirectTohome), for: .touchUpInside)

    }
 
    @objc func redirectTohome() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.loadAndSetupabBar()        
    }

}
