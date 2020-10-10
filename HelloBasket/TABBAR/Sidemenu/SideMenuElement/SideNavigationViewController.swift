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
        ["title":"All Category" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"My Account" as AnyObject,"image": "myOrder" as AnyObject]
        ,["title":"Order History" as AnyObject,"image": "serviceOrder" as AnyObject]
        ,["title":"Hot Deals" as AnyObject,"image": "bookingForPuppy" as AnyObject]
        ,["title":"New Arrival" as AnyObject,"image": "puppyhistory" as AnyObject]
        ,["title":"Share App" as AnyObject,"image": "bookingForSurgery" as AnyObject]
        ,["title":"Discounted Product" as AnyObject,"image": "surgeryHistory" as AnyObject]
        ,["title":"About Us" as AnyObject,"image": "askingQuestion" as AnyObject]
        ,["title":"Terms and Conditions" as AnyObject,"image": "questionHistory" as AnyObject]
        ,["title":"Policy" as AnyObject,"image": "phone" as AnyObject]
        ,["title":"Complaint" as AnyObject,"image": "aboutus" as AnyObject]
        ,["title":"Contact Us" as AnyObject,"image": "complaint" as AnyObject]
        ,["title":"Notification" as AnyObject,"image": "logout" as AnyObject]]
    
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return dataArr.count
        }
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "loginCell") as? sideMenuTableViewCell
        
        cell?.loginButton.layer.borderColor = UIColor.white.cgColor
        cell?.loginButton.layer.borderWidth = 2
        cell?.signUpButton.layer.borderColor = UIColor.white.cgColor
        cell?.signUpButton.layer.borderWidth = 2
        
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
        
        if indexPath.section == 2{
            let cell = self.sideMenuTablevw.dequeueReusableCell(withIdentifier: "socialMediaCell") as? sideMenuTableViewCell
            return cell!
            
        }
//        var cell: sideMenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? sideMenuTableViewCell
//        if cell == nil {
//            tableView.register(UINib(nibName: "sideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "sideMenuTableViewCell")
//            cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuTableViewCell") as? sideMenuTableViewCell
//        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuItem =  dataArr[indexPath.row]["title"] as? String ?? ""
        
        switch menuItem {
        case "All Category":
            
          let storyBoard = UIStoryboard.init(name: "TabbarMenu", bundle: nil)
            if let orderVC = storyBoard.instantiateViewController(withIdentifier: "CategoryTabViewController") as? CategoryTabViewController {
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
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let vc = storyBoard.instantiateViewController(withIdentifier: "ServiceOrderViewController") as? ServiceOrderViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            break
        case "Hot Deals":
            
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let getbookingpuppy = storyBoard.instantiateViewController(withIdentifier: "BookingNewPuppyViewController") as? BookingNewPuppyViewController {
//                self.navigationController?.pushViewController(getbookingpuppy, animated: true)
//            }
            break
        case "New puppy history":
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let genewpuppyhistory = storyBoard.instantiateViewController(withIdentifier: "NewPuppyHistoryViewController") as? NewPuppyHistoryViewController {
//                self.navigationController?.pushViewController(genewpuppyhistory, animated: true)
//            }
            break
            
        case "Booking for a surgery":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let bookForSurgery = storyBoard.instantiateViewController(withIdentifier: "BookingForSurgeryViewController") as? BookingForSurgeryViewController {
//                self.navigationController?.pushViewController(bookForSurgery, animated: true)
//            }
            break
            
        case "Surgery History":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let bookForSurgeryHistory = storyBoard.instantiateViewController(withIdentifier: "BookingSurgeryHistoryViewController") as? BookingSurgeryHistoryViewController {
//                self.navigationController?.pushViewController(bookForSurgeryHistory, animated: true)
//            }
            break
        case "Contact Us":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let getcontact = storyBoard.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController {
//                self.navigationController?.pushViewController(getcontact, animated: true)
//            }
            break
        case "About Us":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let aboutus = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController {
//                self.navigationController?.pushViewController(aboutus, animated: true)
//            }
            break
            
        case "Suggestion/Complaint":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let suggestion = storyBoard.instantiateViewController(withIdentifier: "SuggestionViewController") as? SuggestionViewController {
//                self.navigationController?.pushViewController(suggestion, animated: true)
//            }
            break
            
            
            
            
        case "Asking a Question":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let askquestionVC = storyBoard.instantiateViewController(withIdentifier: "AskingQuestionViewController") as? AskingQuestionViewController {
//                self.navigationController?.pushViewController(askquestionVC, animated: true)
//            }
            break
            
            
        case "Question History":
//            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//            if let askquestionVC = storyBoard.instantiateViewController(withIdentifier: "QuestionHistoryViewController") as? QuestionHistoryViewController {
//                self.navigationController?.pushViewController(askquestionVC, animated: true)
//            }
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
//            }
//
//            // Add the actions
//            alertController.addAction(okAction)
//            alertController.addAction(cancelAction)
//
//            // Present the controller
//            self.present(alertController, animated: true, completion: nil)
            
            break
            
        default:
            break
            
        }
        
    }
    
}
