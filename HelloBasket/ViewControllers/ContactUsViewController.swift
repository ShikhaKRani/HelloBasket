//
//  ContactUsViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 24/10/20.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var whatsappBtn: UIButton!
    @IBOutlet weak var imageLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        whatsappBtn.addTarget(self, action: #selector(redirectToWhatsApp), for: .touchUpInside)
        
    }
    
    @objc func redirectToWhatsApp() {
        let phoneNumber =  contactLbl.text // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber ?? "8888888888")")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            // WhatsApp is not installed
        }
       
    }
    
    @objc func backAction() { self.navigationController?.popViewController(animated: true)    }
    
    
}
    

    

