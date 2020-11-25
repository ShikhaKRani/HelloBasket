//
//  NewLoginViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 25/11/20.
//

import UIKit
import SwiftPhoneNumberFormatter

class NewLoginViewController: UIViewController {
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var mobileTextField : PhoneFormattedTextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var skipButton : UIButton!
        
    
    var mobileNumber = ""
    var rawMobileNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        mobileTextField.layer.cornerRadius = 5
        mobileTextField.layer.borderColor = AppColor.themeColor.cgColor
        mobileTextField.layer.borderWidth = 0.8
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = AppColor.themeColor.cgColor
        loginButton.layer.borderWidth = 0.8
        
        skipButton.layer.cornerRadius = 5
        skipButton.layer.borderColor = AppColor.themeColor.cgColor
        skipButton.layer.borderWidth = 0.8
        
        loginButton.addTarget(self, action: #selector(validateLogin), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(redirectTohome), for: .touchUpInside)

        mobileTextField.config.defaultConfiguration = PhoneFormat(defaultPhoneFormat: "### ###-##-##")
        mobileTextField.prefix = nil
        self.mobileTextField.textDidChangeBlock = { field in
            if let text = field?.text, text != "" {
                print(text)
                self.mobileNumber = text
            } else {
                print("No text")
            }
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func validateLogin() {
        
        self.view.endEditing(true)
        
        self.mobileNumber = self.mobileNumber.replacingOccurrences(of: "-", with: "")
        self.mobileNumber = self.mobileNumber.replacingOccurrences(of: " ", with: "")

        
        var count = 0
        if self.mobileNumber.count != 10 {
            count  = count + 1
            self.view.makeToast("Please enter 10 digit mobile number")
            return
        }
        
        if count == 0 {
            self.validateLoginCredential(mobile: self.mobileNumber )
        }
    }
    
    func validateLoginCredential(mobile : String) {
        
        Loader.showHud()
        let params = ["mobile" : mobile]
        self.rawMobileNumber = mobile
        ServiceClient.sendPOSTRequest(apiUrl: APIEndPoints.shared.Login_OTP, postdatadictionary: params, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                
                print("login call response == : \(res)")
                
                if res["status"] as? String == "success" {
                    
                    DispatchQueue.main.async {
                        self.redirectToOTPScreen()
                    }
                    
                }else{
                    UserDetails.shared.setAccessToken(token:"")
                    Loader.dismissHud()
                }
            }
        }
    }
    
    
    @objc func redirectToOTPScreen() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let otp = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otp.mobile = self.rawMobileNumber
            self.navigationController?.pushViewController(otp, animated: true)
        }
    }
   
    @objc func redirectTohome() {
        Utils.redirectToHome()
    }
    
    

}
