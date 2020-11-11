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
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var addAddressBtn: UIButton!
    @IBOutlet weak var savedLbl: UILabel!
    @IBOutlet weak var headerView: UIView!

    var selectedIndex : Int?
    
    var addressList = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Address"
        self.savedLbl.text = "SAVED ADDRESS"
        self.savedLbl.textColor = AppColor.themeColor
        self.addAddressBtn .setTitleColor(AppColor.themeColor, for: .normal)
        addAddressBtn.addTarget(self, action: #selector(addAddressBtnAction), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextbtnAction), for: .touchUpInside)
        nextBtn.setTitle("Continue", for: .normal)
       
        self.nextBtn .setTitleColor(.white, for: .normal)
        self.nextBtn.backgroundColor = AppColor.themeColor
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
                        print("===>> address list - > \(self.addressList)")
                    }
                }
                DispatchQueue.main.async {
                    
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    func updateSelectedAddressDetails(selectedInd : Int) {
        
        Loader.showHud()

        let dict = self.addressList[selectedInd]
        let address_id = dict["id"] as? Int
        let user_id = dict["user_id"] as? Int

        
        ServiceClient.sendRequestPOSTBearer(apiUrl:"\(APIEndPoints.shared.ADD_DELIVERY_ADDRESS)/\(address_id ?? 0)" , postdatadictionary: ["address_id":"\(address_id ?? 0)"], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    DispatchQueue.main.async {
                        self.redirectToPayNow(selectedInd: address_id ?? 0)
                    }
                    
                }else{
                    
                }
            }
        }
    }
    
    func redirectToPayNow(selectedInd : Int) {
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let det = storyBoard.instantiateViewController(withIdentifier: "PaymentDetailsViewController") as? PaymentDetailsViewController {
            det.selected_address_id = "\(selectedInd)"
            self.navigationController?.pushViewController(det, animated: true)
        }
        
    }
    
    @objc func addAddressBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func nextbtnAction() {
        
        if let index = selectedIndex {
            self.updateSelectedAddressDetails(selectedInd: index)
        }
        else{
            //alert
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
        let pin = dic["pincode"] as? String
        let mobile_no = dic["mobile_no"] as? String
        let street = dic["street"] as? String
        let city = dic["city"] as? String
        let landmark = dic["landmark"] as? String
        let appertment_name = dic["appertment_name"] as? String
        cell?.namelbl.text = "\(name ?? "") \(last ?? "")"
        cell?.l2Lbl.text = "\(appertment_name ?? "")"
        cell?.l3Lbl.text = "\(street ?? "") \(landmark ?? "") \(city ?? "")"

        cell?.pincodeLbl.text = "\(pin ?? "")"
        cell?.phoneLbl.text = "Ph: \(mobile_no ?? "")"

        
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
