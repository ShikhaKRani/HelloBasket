//
//  MyAccountViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 08/10/20.
//

import UIKit

class MyAccountTableViewCell:UITableViewCell{
    
    @IBOutlet weak var nameTextLbl: UILabel!
    @IBOutlet weak var mobileTextLbl: UILabel!
    @IBOutlet weak var emailTextLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var headerTextLbl: UILabel!
    
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var  cellImage: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    
    @IBOutlet weak var walletCellButton: UIButton!
    @IBOutlet weak var  walletCellImage: UIImageView!
    @IBOutlet weak var walletcellLbl: UILabel!
    @IBOutlet weak var  walletRupeeCellLbl: UILabel!
    
    
}

class MyAccountViewController: UIViewController {
    @IBOutlet weak var myAccountTblView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        
        
        
        self.myAccountTblView.tableFooterView = UIView()
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(redirectTohome), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func redirectTohome() {
        let storyBoard = UIStoryboard.init(name: "TabbarMenu", bundle: nil)
        if let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    

}

extension MyAccountViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return 2
        }
        else if section == 2{
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "headerCell") as? MyAccountTableViewCell
        
        if section == 1{
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "headerCell") as? MyAccountTableViewCell
            
            cell?.headerTextLbl.text = "Account Setting"
            
            return cell!
            
        }
        else if section == 2{
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "headerCell") as? MyAccountTableViewCell
            
            cell?.headerTextLbl.text = "Wallet"
            
            return cell!
            
        }
        
        else if section == 3{
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "headerCell") as? MyAccountTableViewCell
            
            cell?.headerTextLbl.text = "Booking"
            
            return cell!
            
        }
        
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "commonCell") as? MyAccountTableViewCell
        
        if indexPath.section == 0{
            
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "profileCell") as? MyAccountTableViewCell
            
            return cell!
        }
        
        else if indexPath.section == 1{
            
            if indexPath.row == 0{
                let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "commonCell") as? MyAccountTableViewCell
                
                cell?.cellLbl.text = "Update Profile"
                cell?.cellImage.image = UIImage(named: "user")
                
                return cell!
                
            }
            
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "commonCell") as? MyAccountTableViewCell
            cell?.cellLbl.text = "Logout"
            cell?.cellImage.image = UIImage(named: "logout")
            
            return cell!
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{
                let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "walletCell") as? MyAccountTableViewCell
                
                cell?.walletCellImage.image = UIImage(named: "wallet")
                
                return cell!
                
            }
            
            if indexPath.row == 1{
                let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "commonCell") as? MyAccountTableViewCell
                cell?.cellLbl.text = "Add Money"
                cell?.cellImage.image = UIImage(named: "moneyBag")
                
                return cell!
                
            }
            cell?.cellImage.image = UIImage(named: "walletHistory")
            //cell?.cellImage.image?.withTintColor(.green)
            cell?.cellLbl.text = "Wallet History"
            
            
        }
        
        if indexPath.section == 3{
            let cell = self.myAccountTblView.dequeueReusableCell(withIdentifier: "commonCell") as? MyAccountTableViewCell
            cell?.cellLbl.text = "Booking History"
            cell?.cellImage.image = UIImage(named: "bookingHistory")
            
            return cell!
            
        }
        
       

        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }
        
        return 50
    }
    
    
}
