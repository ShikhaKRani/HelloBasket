//
//  SideNavigationViewController.swift
//  EDXPERT
//
//  Created by Vibhash Kumar on 16/07/19.
//  Copyright © 2019 Vibhash Kumar. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
class SideNavigationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var profileImgIcon: UIImageView!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var sideMenuTablevw: UITableView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var preficProfileLbl: UILabel!
    @IBOutlet weak var selectedProfileLbl: UILabel!
    @IBOutlet weak var selectedProfileSubTitleLbl: UILabel!
    @IBOutlet weak var unselectedProfileBtn: UIButton!
    
    var dataArr : Array<Dictionary<String,AnyObject>> = [
        ["title":"Membership" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"My Account" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"Order History" as AnyObject,"image": "orderHistory" as AnyObject]
        ,["title":"Hot Deals" as AnyObject,"image": "hotDeals" as AnyObject]
        ,["title":"New Arrival" as AnyObject,"image": "newArrival" as AnyObject]
        ,["title":"Share App" as AnyObject,"image": "share" as AnyObject]
        ,["title":"Discounted Product" as AnyObject,"image": "discount" as AnyObject]
        ,["title":"About Us" as AnyObject,"image": "aboutus" as AnyObject]
        ,["title":"Terms and Conditions" as AnyObject,"image": "terms" as AnyObject]
        ,["title":"Policy" as AnyObject,"image": "privacypolicy" as AnyObject]
        ,["title":"Contact Us" as AnyObject,"image": "contactUs" as AnyObject]
        ,["title":"Notification" as AnyObject,"image": "notification" as AnyObject]]
    
    let dropDown = DropDown()
    
    let  cellReuseIdentifier = "sideMenuTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuView.backgroundColor = AppColor.themeColor
        self.sideMenuTablevw.backgroundColor = .tertiarySystemGroupedBackground
        sideMenuTablevw.delegate = self
        sideMenuTablevw.dataSource = self
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // updateProfilePic()
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @objc func logout() {
        UserDetails.shared.setAccessToken(token: "")
        Utils.redirectToLogin()
    }
    
    @objc func loginAction() {
        UserDetails.shared.setAccessToken(token: "")
        Utils.redirectToLogin()
    }
    
    @objc func signUpAction() {
        UserDetails.shared.setAccessToken(token: "")
        Utils.redirectToLogin()
    }
    
    //MARK:- delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return dataArr.count
        }
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "socialMediaCell") as? sideMenuTableViewCell

        
        if indexPath.section == 0 {
            let token = UserDetails.shared.getAccessToken()
            
            if token.count > 0 {
                let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "logoutCell") as? sideMenuTableViewCell
                cell?.loginButton.layer.borderColor = UIColor.white.cgColor
                cell?.loginButton.layer.borderWidth = 2
                cell?.loginButton.setTitle("Logout", for: .normal)
                cell?.loginButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
                return cell!
            }else{
                let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "loginCell") as? sideMenuTableViewCell
                cell?.loginButton.layer.borderColor = UIColor.white.cgColor
                cell?.loginButton.layer.borderWidth = 2
                cell?.signUpButton.layer.borderColor = UIColor.white.cgColor
                cell?.signUpButton.layer.borderWidth = 2
                cell?.loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
                cell?.signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
                return cell!
            }
        }
        
        
        if indexPath.section == 1{
            let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "imgCell") as? sideMenuTableViewCell
            
            let cellDict = dataArr[indexPath.row] as Dictionary<String,AnyObject>
            cell?.menuImgIcon.image = UIImage.init(named: cellDict["image"] as? String ?? "")
            cell?.menuTitleLbl.text = cellDict["title"] as? String ?? ""
            cell?.selectionStyle  = .none
            if cell?.menuTitleLbl.text == "Discounted Product"{
                cell?.lineView.isHidden = false
            }
            else{
                cell?.lineView.isHidden = true
            }
            
            return cell!
            
        }
        
        if indexPath.section == 2 {
            let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "socialMediaCell") as? sideMenuTableViewCell
            return cell!
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuItem =  dataArr[indexPath.row]["title"] as? String ?? ""
        
        switch menuItem {

        case "Membership":
            
          let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let orderVC = storyBoard.instantiateViewController(withIdentifier: "MembershipViewController") as? MembershipViewController {
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
            
            break
            
        case "My Account":
            
            //OrderViewController
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let orderVC = storyBoard.instantiateViewController(withIdentifier: "MyAccountViewController") as? MyAccountViewController {
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
            
            break
            
        case "Order History":

            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let deals = storyBoard.instantiateViewController(withIdentifier: "OrderHistoryViewController") as? OrderHistoryViewController {

                self.navigationController?.pushViewController(deals, animated: true)
            }
            
            
            break
        case "Hot Deals":
            
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let deals = storyBoard.instantiateViewController(withIdentifier: "HotDealsViewController") as? HotDealsViewController {
                deals.screen = "Hot Deals"

                self.navigationController?.pushViewController(deals, animated: true)
            }
            break
        case "New Arrival":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let deals = storyBoard.instantiateViewController(withIdentifier: "HotDealsViewController") as? HotDealsViewController {
                deals.screen = "New Arrival"

                self.navigationController?.pushViewController(deals, animated: true)
            }
            break
            
        case "Discounted Product":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let deals = storyBoard.instantiateViewController(withIdentifier: "HotDealsViewController") as? HotDealsViewController {
                deals.screen = "Discounted Product"
                self.navigationController?.pushViewController(deals, animated: true)
            }
            break
            
        case "About Us":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController {
                vc.screen = "aboutus"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case "Terms and Conditions":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController {
                vc.screen = "tc"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        case "Policy":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let vc = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController {
                vc.screen = "policy"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break            
      
        case "Contact Us":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let contact = storyBoard.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController {
                //deals.screen = "Discounted Product"
                self.navigationController?.pushViewController(contact, animated: true)
            }
            break
            
            
        case "Notification":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let contact = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController {
                self.navigationController?.pushViewController(contact, animated: true)
            }

            break
            
        case "Logout":
            
//            let alertController = UIAlertController(title: "Alert", message: "Are you sure you want to logout", preferredStyle: .alert)
//
//            // Create the actions
//            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                UIAlertAction in
//                UserDefaults.standard.removeObject(forKey: "id")
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let newViewController = storyBoard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
//                let navigationController = UINavigationController(rootViewController: newViewController)
//                let appdelegate = UIApplication.shared.delegate as! AppDelegate
//                appdelegate.window!.rootViewController = navigationController
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//                UIAlertAction in
//
//  
            break
            
        default:
            break
            
        }
        
    }
    
}
