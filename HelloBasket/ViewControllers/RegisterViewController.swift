//
//  RegisterViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 05/10/20.
//

import UIKit
import IQKeyboardManagerSwift

class RegisterTableViewCell: UITableViewCell{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerSubmibutton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var mobileImageView: UIImageView!
    @IBOutlet weak var passowrdImageView: UIImageView!
    @IBOutlet weak var confirmpassImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmpassView: UIView!
    
}
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registertblView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationView.backgroundColor = AppColor.themeColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.imageTapped(gesture:)))

                // add it to the image view;
        backImageView.addGestureRecognizer(tapGesture)
                // make sure imageView can be interacted with by user
        backImageView.isUserInteractionEnabled = true

        
    }
    
    @objc func redirectToLogin() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if storyBoard.instantiateViewController(withIdentifier: "LoginViewController") is LoginViewController {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
            // if the tapped view is a UIImageView then set it to imageview
            if (gesture.view as? UIImageView) != nil {
                print("Image Tapped")
                redirectToLogin()
                
                //Here you can initiate your new ViewController

            }
        }
    

}

//MARK:- Table View Delegate
extension RegisterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.registertblView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell") as? RegisterTableViewCell
        
        cell?.registerSubmibutton.backgroundColor =  AppColor.themeColor
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
