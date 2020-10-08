//
//  LoginViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class LoginTableViewCell: UITableViewCell{
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotbutton: UIButton!
    @IBOutlet weak var nextbutton: UIButton!
    @IBOutlet weak var loginWithOtpbutton: UIButton!
    @IBOutlet weak var skipbutton: UIButton!
    @IBOutlet weak var registerbutton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
}

class LoginViewController: UIViewController {

    @IBOutlet weak var logintblView: UITableView!
    @IBOutlet weak var navigationView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        navigationView.backgroundColor = AppColor.themeColor
        

    }
 
    @objc func redirectTohome() {
        Utils.redirectToHome()
    }
    
    @objc func redirectToRegisterPage() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let registerVC = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController {
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
    }

}

//MARK:- Table View Delegate
extension LoginViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.logintblView.dequeueReusableCell(withIdentifier: "LoginTableViewCell") as? LoginTableViewCell
        
        cell?.nextbutton.backgroundColor = .none
        cell?.nextbutton.layer.borderColor = UIColor.lightGray.cgColor
        cell?.nextbutton.layer.borderWidth = 1
        cell?.nextbutton.layer.cornerRadius = 5
        
        cell?.loginWithOtpbutton.backgroundColor = .none
        cell?.loginWithOtpbutton.layer.borderColor = UIColor.lightGray.cgColor
        cell?.loginWithOtpbutton.layer.borderWidth = 1
        cell?.loginWithOtpbutton.layer.cornerRadius = 5
        
        cell?.skipbutton.backgroundColor = .none
        cell?.skipbutton.layer.borderColor = UIColor.lightGray.cgColor
        cell?.skipbutton.layer.borderWidth = 1
        cell?.skipbutton.layer.cornerRadius = 5
        
        
        
        cell?.self.skipbutton.addTarget(self, action: #selector(redirectTohome), for: .touchUpInside)
        
        cell?.self.registerbutton.addTarget(self, action: #selector(redirectToRegisterPage), for: .touchUpInside)
        
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
