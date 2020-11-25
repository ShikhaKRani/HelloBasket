//
//  OTPViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 25/11/20.
//


import UIKit
import DPOTPView


class OTPViewController: UIViewController {
    
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var txtDPOTPView: DPOTPView!
    
    var mobile : String?
    var otpString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        submitBtn.addTarget(self, action: #selector(submitOTPChange), for: .touchUpInside)

        
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderColor = AppColor.themeColor.cgColor
        submitBtn.layer.borderWidth = 0.8
        submitBtn.backgroundColor = AppColor.themeColor
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtDPOTPView.dpOTPViewDelegate = self
        txtDPOTPView.textEdgeInsets = UIEdgeInsets(top: 0, left: -1, bottom: 0, right: 0)
        txtDPOTPView.editingTextEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        txtDPOTPView.fontTextField = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(25.0))!
        
        
    }
    
    @objc func submitOTPChange(){
        self.verifyOtp()
    }
    
    func verifyOtp() {
        
        self.mobile = self.mobile?.replacingOccurrences(of: "-", with: "")
        self.mobile = self.mobile?.replacingOccurrences(of: " ", with: "")
      
        if otpString?.count == 6  && self.mobile?.count == 10 {
            self.loginUserWithOtp(mobile: self.mobile ?? "")
        }else{
        }
    }
    
    func loginUserWithOtp(mobile: String) {
        
        let param: [String: Any] = [
            "mobile": mobile ,
            "otp": otpString ?? "",
            "type": "login"
        ]
        Loader.showHud()
        
        ServiceClient.sendPOSTRequest(apiUrl: APIEndPoints.shared.VERIFY_OTP, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                
                print("login call response == : \(res)")
                
                if res["status"] as? String == "success" {
                    
                    if let token = res["token"] as? String {
                        UserDetails.shared.setAccessToken(token:token)
                    }
                    DispatchQueue.main.async {
                        Utils.redirectToHome()
                    }
                    
                }else{
                    UserDetails.shared.setAccessToken(token:"")
                    Loader.dismissHud()
                }
            }
        }
    }
    
    
}

extension OTPViewController : DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        print("addText:- " + text + " at:- \(position)" )
        otpString = text
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        print("removeText:- " + text + " at:- \(position)" )
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
        print("at:-\(position)")
    }
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
    }
}


