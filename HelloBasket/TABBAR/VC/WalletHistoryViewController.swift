//
//  WalletHistoryViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 03/11/20.
//

import UIKit

class WalletHistoryCell : UITableViewCell {
    @IBOutlet weak var bookingIdtitleLbl: UILabel!
    @IBOutlet weak var bookingIdLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!

}


class WalletHistoryViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var balancehisBtn: UIButton!
    @IBOutlet weak var cashBackbtn: UIButton!

    
    var screen : String?
    var option_Selected : String?

    
    var wholeDataDict : [String:Any]?
    var balanceHistory = [[String:Any]]()
    var cashBackHistory = [[String:Any]]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Wallet History"
        self.option_Selected = self.screen
        
        balancehisBtn.addTarget(self, action: #selector(balanceHistorybtnAction(sender:)), for: .touchUpInside)
        cashBackbtn.addTarget(self, action: #selector(cashbackHistorybtnAction(sender:)), for: .touchUpInside)

        if option_Selected == "wallethistory" {
            balancehisBtn.isSelected = true
            cashBackbtn.isSelected = false
        }
        else{
            balancehisBtn.isSelected = false
            cashBackbtn.isSelected = true
        }
        
        
        self.fetchWalletHistoryDetails()
        
    }

    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    @objc func balanceHistorybtnAction(sender : UIButton) {
        self.option_Selected = "wallethistory"
        
        balancehisBtn.isSelected = true
        cashBackbtn.isSelected = false

        
        
        self.tblView.reloadData()
        
    }
    @objc func cashbackHistorybtnAction(sender : UIButton) {
        self.option_Selected = "cashback"
        balancehisBtn.isSelected = false
        cashBackbtn.isSelected = true

        
        self.tblView.reloadData()
    }
    
    func fetchWalletHistoryDetails() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:APIEndPoints.shared.WALLET_HISTORY , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String: Any] {
                        self.wholeDataDict = data
                        print(self.wholeDataDict ?? [:])
                        self.balanceHistory.removeAll()
                        self.cashBackHistory.removeAll()
                        if let balData = self.wholeDataDict?["history"] as? [[String: Any]] {
                            self.balanceHistory = balData
                        }
                        if let cashback = self.wholeDataDict?["cashback"] as? [[String: Any]] {
                            self.cashBackHistory = cashback
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    
    
    
    
}

extension WalletHistoryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.option_Selected == "cashback" {
            return self.cashBackHistory.count
        }
        else if self.option_Selected == "wallethistory" {
            return self.balanceHistory.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "WalletHistoryCell") as? WalletHistoryCell
        var dic : [String: Any] = [:]
        if self.option_Selected == "cashback" {
            dic = self.cashBackHistory[indexPath.section]
        }
        else{
            dic = self.balanceHistory[indexPath.section]
        }
        
        
        cell?.bookingIdtitleLbl.textColor = AppColor.themeColorSecond
        cell?.bookingIdLbl.textColor = AppColor.themeColorSecond
        cell?.creditLbl.textColor = AppColor.themeColorSecond
        cell?.amountlbl.textColor = AppColor.themeColorSecond
        cell?.descLbl.textColor = .gray
        
        
        cell?.bookingIdLbl.text = "\(dic["refid"] ??  "")"
        cell?.creditLbl.text = "\(dic["type"] ??  "")"
        cell?.amountlbl.text = "\(StringConstant.RupeeSymbol)\(dic["amount"] ??  0)"
        cell?.descLbl.text = "\(dic["description"] ??  "")"

        
        return cell!
    }
    
    
}
