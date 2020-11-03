//
//  CustomerAddressListViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 03/11/20.
//

import UIKit

class CustAddressCell: UITableViewCell {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var l2Lbl: UILabel!
    @IBOutlet weak var l3Lbl: UILabel!
    @IBOutlet weak var pincodeLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!

}

class CustomerAddressListViewController: UIViewController {

    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
       
    var selectedIndex : Int?
    
    var addressList = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Address"
        
        self.fetchCustomerAddressDetails()
        

    }
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    
    func fetchCustomerAddressDetails() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:APIEndPoints.shared.CUSTOMER_ADDRESS , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["message"] as? String == "success" {
                    if let data = res["data"] as? [[String: Any]] {
                        self.addressList.removeAll()
                        self.addressList = data
                        
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    
}


extension CustomerAddressListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "CustAddressCell") as? CustAddressCell
        
        let dic = self.addressList[indexPath.section]
        
        cell?.img.image = UIImage(named: "radioUnselected")
        cell?.titlelbl.text = dic["address_type"] as? String
        
        let name =  dic["first_name"] as? String
        let last = dic["last_name"] as? String
        
        cell?.namelbl.text = "\(name ?? "") \(last ?? "")"
        
        if selectedIndex == indexPath.section {
            cell?.img.image = UIImage(named: "radioselected")
        }
        
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.section
        self.tblView.reloadData()
    }
    
    
}
