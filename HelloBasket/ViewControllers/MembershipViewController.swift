//
//  MembershipViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 03/11/20.
//

import UIKit


class MembershipCell : UITableViewCell {
    @IBOutlet weak var activelbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var validityLbl: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!
}

class MembershipViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    var membershipList = [[String : Any]]()
    var  activeSubscription :[String : Any]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Membership"
        
        self.fetchMemberShipList()
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    @objc func subscribeBtnAction(sender : UIButton) {
        
        let dict = self.membershipList[sender.tag]
        let is_active = self.activeSubscription?["is_active"] as? Int
        let plan_id = self.activeSubscription?["plan_id"] as? Int
        let Member_id = dict["id"] as? Int

        if is_active == 1 {
            if Member_id != plan_id {
                self.updateSubscription(subscriptionid: "\(Member_id ?? 0)")
            }
        }else{
            self.updateSubscription(subscriptionid: "\(Member_id ?? 0)")
        }
        
    }

    
    func fetchMemberShipList() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:APIEndPoints.shared.MEMBERSHIP , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String: Any] {
                        if let memberships = data["memberships"] as? [[String: Any]] {
                            self.membershipList.removeAll()
                            self.membershipList = memberships
                            self.activeSubscription = data["active"] as? [String:Any] ?? [:]
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    func updateSubscription(subscriptionid : String) {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.SUBSCRIBE)/\(subscriptionid)" , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                let msg = res["message"] as? String
                
                if res["status"] as? String == "success" {
                    DispatchQueue.main.async {
                        self.view.makeToast("\(msg ?? "")", duration: 3.0, position: .bottom)
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.view.makeToast("\(msg ?? "")", duration: 3.0, position: .bottom)
                    }
                }
            }
        }
    }
    
}

extension MembershipViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.membershipList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "MembershipCell") as? MembershipCell
        
        let dict = self.membershipList[indexPath.row]
        
        cell?.nameLbl.text = "\(dict["name"] ?? "")"
        cell?.nameLbl.textColor = AppColor.themeColor
        cell?.validityLbl.textColor = .gray
        cell?.pricelbl.textColor = .gray
        cell?.pricelbl.text = "\(StringConstant.RupeeSymbol)\(dict["price"] ?? "0")"
        cell?.validityLbl.text = "\(StringConstant.RupeeSymbol)\(dict["validity"] ?? "0") Days"
        
        cell?.subscribeBtn.layer.borderWidth = 1
        cell?.subscribeBtn.layer.cornerRadius = 5
        cell?.subscribeBtn.layer.borderColor = UIColor.lightGray.cgColor
        cell?.subscribeBtn .setTitleColor(.red, for: .normal)
        cell?.subscribeBtn .setTitle("Subscrible", for: .normal)
        cell?.activelbl.textColor = .gray
        cell?.subscribeBtn.addTarget(self, action: #selector(subscribeBtnAction(sender:)), for: .touchUpInside)
        
        cell?.subscribeBtn.tag = indexPath.row
        
        let is_active = self.activeSubscription?["is_active"] as? Int
        let plan_id = self.activeSubscription?["plan_id"] as? Int
        cell?.activelbl.isHidden = true
        if is_active == 1 {
            
            let Member_id = dict["id"] as? Int
            if Member_id == plan_id {
                cell?.activelbl.isHidden = false
                cell?.subscribeBtn.layer.borderWidth = 2
                cell?.subscribeBtn.layer.cornerRadius = 5
                cell?.subscribeBtn.layer.borderColor = AppColor.themeColor.cgColor
                cell?.subscribeBtn .setTitleColor(AppColor.themeColor, for: .normal)
                cell?.activelbl.textColor = AppColor.themeColor
            }
        }
        return cell!
    }
    
}
