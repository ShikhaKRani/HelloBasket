//
//  LoginViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 04/10/20.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftPhoneNumberFormatter


class LoginTableViewCell: UITableViewCell{
    @IBOutlet weak var numberTextField: PhoneFormattedTextField!
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

    
    var mobileNumber : String?
    var passowrd : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationView.backgroundColor = AppColor.themeColor
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    @objc func validateLogin() {
        
        self.view.endEditing(true)
        var count = 0
        if self.mobileNumber?.count != 10 {
            count  = count + 1
        }
        if self.passowrd?.count ?? 0 < 4 {
            count  = count + 1
        }
        
        if count == 0 {
            self.validateLoginCredential()
        }
    }
    
    func validateLoginCredential() {
        
        Loader.showHud()
        let params = ["user_id": "\(self.mobileNumber ?? "")", "password" : "\(self.passowrd ?? "")"] as Dictionary<String, String>
        
        ServiceClient.sendPOSTRequest(apiUrl: APIEndPoints.shared.LOGIN, postdatadictionary: params, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                
                print("login call response == : \(res)")
                
                if res["status"] as? String == "success" {
                    
                    if let token = res["token"] as? String {
                        UserDetails.shared.setAccessToken(token:token)
                    }
                    DispatchQueue.main.async {
                        self.redirectTohome()
                    }
                    
                }else{
                    UserDetails.shared.setAccessToken(token:"")
                    Loader.dismissHud()
                }
            }
        }
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


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 100 {
            self.passowrd = textField.text
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
        cell?.passwordTextField.tag = 100
        cell?.passwordTextField.delegate = self
        cell?.numberTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### ###-##-##")
        cell?.numberTextField.prefix = nil
        cell?.numberTextField.textDidChangeBlock = { field in
            if let text = field?.text, text != "" {
                print(text)
                self.mobileNumber = text
                self.mobileNumber = self.mobileNumber?.replacingOccurrences(of: "-", with: "")
                self.mobileNumber = self.mobileNumber?.replacingOccurrences(of: " ", with: "")

                
            } else {
                print("No text")
            }
        }
        
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
        
        cell?.self.nextbutton.addTarget(self, action: #selector(validateLogin), for: .touchUpInside)

        
        cell?.self.skipbutton.addTarget(self, action: #selector(redirectTohome), for: .touchUpInside)
        
        cell?.self.registerbutton.addTarget(self, action: #selector(redirectToRegisterPage), for: .touchUpInside)
        
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
