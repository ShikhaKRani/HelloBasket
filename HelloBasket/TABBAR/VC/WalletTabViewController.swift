//
//  WalletTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//

import UIKit
import IQKeyboardManagerSwift

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
    
    var amountField = ""
    var pay = PaymentViewController()
    var walletBalance = "0"
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var walletTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor
        walletTblView.tableFooterView = UIView()
        
        self.fetchWalletBalance()
    }
    
    @objc func addMoney(){
        addMoneyBtnAction(payAmount: amountField)
    }
    
    @objc  func add1000Money() {
        amountField = "1000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func add2000Money() {
        amountField = "2000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func add3000Money(){
        
        amountField = "3000"
        let indexPath = IndexPath(item: 0, section: 0)
        walletTblView.reloadRows(at: [indexPath], with: .none)
    }
    
    func addMoneyBtnAction(payAmount : String) {
        
        let param: [String: Any] = ["amount":payAmount]
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.GET_WALLETRECHARGE, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                print(res)
                let responseDict = res["data"] as? Dictionary<String,Any>
                let payStr = (responseDict?["amount"] ?? "0")
                let orderIDStr = (responseDict?["order_id"] ?? "0")
                
                
                DispatchQueue.main.async {
                    self.walletTblView.reloadData()
                    self.pay.addMoneyToPay(amount: "\(payStr)", payOrderid: "\(orderIDStr)", screen: "wallet")
                    
                }
            }
        }
    }
    
    func fetchWalletBalance() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:APIEndPoints.shared.WALLET_BALANCE , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                    self.walletBalance = "\(res["balance"] ?? 0)"
                DispatchQueue.main.async {
                    self.walletTblView.reloadData()
                }
            }
        }
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
            cell?.amountTextfield.delegate = self
            cell?.amountTextfield.text = amountField
            cell?.walletBalanceLbl.text = "\(StringConstant.RupeeSymbol) \(self.walletBalance)"
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
        
        cell?.oneThousandBtn.addTarget(self, action: #selector(add1000Money), for: .touchUpInside)
        cell?.twoThousandBtn.addTarget(self, action: #selector(add2000Money), for: .touchUpInside)
        cell?.threeThousandBtn.addTarget(self, action: #selector(add3000Money), for: .touchUpInside)
        
        cell?.addMoneyBtn.addTarget(self, action: #selector(addMoney), for: .touchUpInside)

            return cell!
        }
        
       else if indexPath.section == 2{
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2{
            return 60
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
           
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            
            if indexPath.row == 0{
                if let vc = storyBoard.instantiateViewController(withIdentifier: "WalletHistoryViewController") as? WalletHistoryViewController {
                    vc.screen = "wallethistory"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if indexPath.row == 1{
                if let vc = storyBoard.instantiateViewController(withIdentifier: "WalletHistoryViewController") as? WalletHistoryViewController {
                    vc.screen = "cashback"
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }

    
}

extension WalletTabViewController : UITextFieldDelegate {
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       amountField = textField.text ?? ""
    }
}
