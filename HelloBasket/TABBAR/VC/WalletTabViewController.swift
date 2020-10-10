//
//  WalletTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//

import UIKit

class WalletCell : UITableViewCell {
    
    
    @IBOutlet weak var walletBalanceLbl: UILabel!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var oneThousandBtn: UIButton!
    @IBOutlet weak var twoThousandBtn: UIButton!
    @IBOutlet weak var threeThousandBtn: UIButton!
    @IBOutlet weak var addMoneyBtn: UIButton!
    @IBOutlet weak var commonimg: UIImageView!
    @IBOutlet weak var commonBtn: UIButton!
    @IBOutlet weak var commonLbl: UILabel!
    
}

class WalletTabViewController: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var walletTblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor
        
        walletTblView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }
    

   
}

extension WalletTabViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    
}


extension WalletTabViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "walletBalance") as? WalletCell
        
        if indexPath.section == 0{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "walletBalance") as? WalletCell
            
            return cell!
            
        }
        
       else if indexPath.section == 1{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "rupeesCell") as? WalletCell
        
        cell?.oneThousandBtn.layer.cornerRadius = 5
        cell?.oneThousandBtn.backgroundColor = .none
        cell?.oneThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.oneThousandBtn.layer.borderWidth = 1
        
        cell?.twoThousandBtn.layer.cornerRadius = 5
        cell?.twoThousandBtn.backgroundColor = .none
        cell?.twoThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.twoThousandBtn.layer.borderWidth = 1
        
        cell?.threeThousandBtn.layer.cornerRadius = 5
        cell?.threeThousandBtn.backgroundColor = .none
        cell?.threeThousandBtn.layer.borderColor = UIColor.black.cgColor
        cell?.threeThousandBtn.layer.borderWidth = 1
            
            return cell!
            
        }
        
       else if indexPath.section == 2{
        let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
        
        if indexPath.row == 0{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
            
                cell?.commonLbl.text = "Balance History"
                cell?.commonimg.image = UIImage(named: "wallet")
            
            return cell!
            
        }
        
        if indexPath.row == 1{
            let cell = self.walletTblView.dequeueReusableCell(withIdentifier: "commonCell") as? WalletCell
            
            cell?.commonLbl.text = "Cash Back History"
            cell?.commonimg.image = UIImage(named: "walletHistory")
                
            
            return cell!
            
        }
            
        
            
        }
        
        return cell!
    }
    
    
}
