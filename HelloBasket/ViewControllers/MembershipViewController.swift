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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Membership"
        
        self.fetchMemberShipList()
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    
    func fetchMemberShipList() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:APIEndPoints.shared.MEMBERSHIP , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["message"] as? String == "success" {
                    if let data = res["data"] as? [[String: Any]] {
                        
//                        self.addressList.removeAll()
//                        self.addressList = data
//                        print("===>> address list - > \(self.addressList)")
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
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
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "MembershipCell") as? MembershipCell
        
    
        
       
        return cell!
    }
    
}
