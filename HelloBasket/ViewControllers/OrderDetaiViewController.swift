//
//  OrderDetaiViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 02/11/20.
//

import UIKit


class OrderFirstCell : UITableViewCell {
    @IBOutlet weak var orderIdlbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!

}

class ButtonCell : UITableViewCell {
    @IBOutlet weak var cancelbtn: UIButton!
}

class OrderItemCell  : UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ItemImgView: UIImageView!

}


class OrderDeliverySlotCell  : UITableViewCell {
    
    @IBOutlet weak var toDLbl: UILabel!
    @IBOutlet weak var deliveryAtlbl: UILabel!
}


class ItemDetailCell  : UITableViewCell {
    @IBOutlet weak var totalPricelbl: UILabel!
    @IBOutlet weak var coupamDisLbl: UILabel!
    @IBOutlet weak var delChargeLbl: UILabel!
    @IBOutlet weak var totalPaidLbl: UILabel!
    @IBOutlet weak var savingLbl: UILabel!
}

class OrderAddressCell  : UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var Addr1lbl: UILabel!
    @IBOutlet weak var Addr2lbl: UILabel!
    @IBOutlet weak var Phonelbl: UILabel!
    
}


class OrderDetaiViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    var orderId : String?
    var wholeDataDict : [String:  Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Order History"
        
        self.fetchOrderHistoryDetails(orderId: self.orderId ?? "44")
        
    }

    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    
    func fetchOrderHistoryDetails(orderId: String) {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.ORDER_HISTORY_DETAILS)/\(orderId )" , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String: Any] {
                        self.wholeDataDict = data
                        print(data)
                    }
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    @objc func cancelBtnAction (sender : UIButton ) {
        
        let myalert = UIAlertController(title: "Alert", message: "Are you sure, you want to cancel this order!!.", preferredStyle: .alert)
        
        myalert.addAction(UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Selected")
            self.makeApiCallToCancelOrder()
            
        })
        myalert.addAction(UIAlertAction(title: "CANCEL", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
        })
        
        self.present(myalert, animated: true)
    }
    
    func makeApiCallToCancelOrder() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.CANCEL_ORDER)/\(self.orderId ?? "")" , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    DispatchQueue.main.async {
                        let msg = res["message"] as? String
                        let myalert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
                        myalert.addAction(UIAlertAction(title: "ORDER LIST", style: .default) { (action:UIAlertAction!) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        myalert.addAction(UIAlertAction(title: "DISMISS", style: .cancel) { (action:UIAlertAction!) in
                            self.fetchOrderHistoryDetails(orderId: self.orderId ?? "")
                        })
                        self.present(myalert, animated: true)
                    }
                }
            }
        }
    }
    
}
extension OrderDetaiViewController : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let show_cancel_product = self.wholeDataDict?["show_cancel_product"] as? Int
        
        if show_cancel_product == 1 {
            return 6
        }
        return 5

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
        let items = self.wholeDataDict?["itemdetails"] as? [[String: Any]]
            
            return items?.count ?? 0
        }
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderFirstCell") as? OrderFirstCell
        
        if indexPath.section == 0 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderFirstCell") as? OrderFirstCell

            let dic = self.wholeDataDict?["orderdetails"] as? [String: Any]
            
            cell?.orderIdlbl.text = dic?["refid"] as? String
            cell?.statusLbl.text = dic?["status"] as? String

            cell?.orderIdlbl.textColor = AppColor.themeColor
            cell?.statusLbl.textColor = AppColor.themeColorSecond
            return cell!

        }
        
        if indexPath.section == 1 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderItemCell") as? OrderItemCell

            let items = self.wholeDataDict?["itemdetails"] as? [[String: Any]]
            let dic = items?[indexPath.row]
            cell?.nameLbl.text = dic?["name"] as? String
            let size = dic?["size"] as? String
            let quant = dic?["quantity"] as? Int
            let price = dic?["price"] as? String
            cell?.sizeLbl.text = "Size \(size ?? "") Quantity \(quant ?? 0)"
            cell?.priceLbl.text = "\(StringConstant.RupeeSymbol) \(price ?? "")"
            let urlString  =  dic?["image"] as? String
            cell?.ItemImgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            return cell!
        }
        
        if indexPath.section == 2 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "ItemDetailCell") as? ItemDetailCell
            let dic = self.wholeDataDict?["prices"] as? [String: Any]
           
            let price = dic?["total"] as? Int
            cell?.totalPricelbl.text = "\(StringConstant.RupeeSymbol)\(price ?? 0)"
            let coupon = dic?["coupon_discount"] as? Int
            cell?.coupamDisLbl.text = "\(StringConstant.RupeeSymbol)\(coupon ?? 0)"
            let del = dic?["delivery_charge"] as? Int
            cell?.delChargeLbl.text = "\(StringConstant.RupeeSymbol)\(del ?? 0)"
            let paid = dic?["total_paid"] as? Int
            cell?.totalPaidLbl.text = "\(StringConstant.RupeeSymbol)\(paid ?? 0)"
            let sav = dic?["total_savings"] as? Int
            cell?.savingLbl.text = "\(StringConstant.RupeeSymbol)\(sav ?? 0)"
            
            
            cell?.totalPricelbl.textColor = AppColor.themeColor
            cell?.totalPaidLbl.textColor = AppColor.themeColor

            

            return cell!
        }
        
        
        
        if indexPath.section == 3 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderDeliverySlotCell") as? OrderDeliverySlotCell
            let dic = self.wholeDataDict?["time_slot"] as? [String: Any]
            cell?.toDLbl.text = dic?["delivery_time"] as? String
            cell?.deliveryAtlbl.text = dic?["delivered_at"] as? String
            
            
            cell?.toDLbl.textColor = AppColor.themeColor
            cell?.deliveryAtlbl.textColor = AppColor.themeColor

            return cell!
        }
        
       
        if indexPath.section == 4{
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderAddressCell") as? OrderAddressCell
            let dic = self.wholeDataDict?["deliveryaddress"] as? [String: Any]
            
            let name1 = dic?["first_name"] as? String
            let name2 = dic?["last_name"] as? String
            cell?.nameLbl.text = "\(name1 ?? "") \(name2 ?? "")"
            
            let hno = dic?["house_no"] as? String
            let app = dic?["appertment_name"] as? String
            let city = dic?["city"] as? String
            let landmark = dic?["landmark"] as? String
            let pincode = dic?["pincode"] as? String
            let mobile_no = dic?["mobile_no"] as? String
            
            cell?.Addr1lbl.text = "HNO. \(hno ?? ""), \(app ?? ""), \(city ?? "")"
            cell?.Addr2lbl.text = "Landmark: \(landmark ?? ""), Pincode:\(pincode ?? "")"
            cell?.Phonelbl.text = "Phone: \(mobile_no ?? "")"

            return cell!
        }
        
        
        if indexPath.section == 5 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "ButtonCell") as? ButtonCell
            cell?.cancelbtn.addTarget(self, action: #selector(cancelBtnAction(sender:)), for: .touchUpInside)
            cell?.cancelbtn.setTitle("CANCEL", for: .normal)
            cell?.cancelbtn.setTitleColor(.white, for: .normal)
            cell?.cancelbtn.backgroundColor = AppColor.themeColor
            
            return cell!
        }
        return cell!
    }
    
   
}
