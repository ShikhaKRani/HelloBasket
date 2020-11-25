//
//  AboutUsViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 25/11/20.
//

import UIKit
import WebKit



class AboutUsViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    var screen : String?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.setUpWeb()
        
        
      
    }
    
    func setUpWeb() {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.bgView.frame.size.width, height: self.bgView.frame.size.height))
        self.bgView.addSubview(webView)
       
        
        var url = URL(string: "")
        if screen == "policy" {
            navTitle.text = "Privacy Policy"

            url = URL(string: "http://hallobasket.appoffice.xyz/url/privacy-policy")
        }
        if screen == "tc" {
            navTitle.text = "Terms and Conditions"

            url = URL(string: "http://hallobasket.appoffice.xyz/url/terms-condition")
        }
        if screen == "aboutus" {
            navTitle.text = "About Us"

            url = URL(string: "http://hallobasket.appoffice.xyz/url/about-us")
        }
        if screen == "refund" {
            navTitle.text = "Refund Policy"

            url = URL(string: "http://hallobasket.appoffice.xyz/url/refund-policy")
        }
        if screen == "cancel" {
            navTitle.text = "Cancellation Policy"

            url = URL(string: "http://hallobasket.appoffice.xyz/url/cancellation-policy")
        }
        
        

        if let webUrl = url {
            webView.load(URLRequest(url: webUrl))
        }
        
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    
}
