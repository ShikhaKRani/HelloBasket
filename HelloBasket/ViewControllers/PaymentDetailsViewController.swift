//
//  PaymentDetailsViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 11/11/20.
//

import UIKit


class DetailAddressCell: UITableViewCell {
    @IBOutlet weak var topHeaderlbl: UILabel!
    @IBOutlet weak var l1lbl: UILabel!
    @IBOutlet weak var l2lbl: UILabel!
    @IBOutlet weak var l3lbl: UILabel!
}


class TimeSlotCell: UITableViewCell {
    @IBOutlet weak var topHeaderlbl: UILabel!
    @IBOutlet weak var field: UITextField!
    
}

class DetailPriceCell: UITableViewCell {
    @IBOutlet weak var l1lbl: UILabel!
    @IBOutlet weak var costlbl: UILabel!
}

class CouponCell: UITableViewCell {
    @IBOutlet weak var couponfield: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
}

class DetailWalletCell: UITableViewCell {
    @IBOutlet weak var l1lbl: UILabel!
    @IBOutlet weak var costlbl: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
}

class DetailItemCell: UITableViewCell {
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var cutPriceLbl: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
}



class PaymentDetailsViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var codBtn: UIButton!
    @IBOutlet weak var paynowBtn: UIButton!

    
    var selected_address_id : String?
    var wholeDict : [String : Any] = [:]
    var itemdetailsList : [[String : Any]] = [[:]]
    var isSelected : Bool?
    var timeSlotSelectedIndex : Int?
    var pay = PaymentViewController()
    var useWalletBalance : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("CartNotificationIdentifier"), object: nil)

        isSelected = false
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        paynowBtn.addTarget(self, action: #selector(payNowbtnAction(sender:)), for: .touchUpInside)

        self.itemdetailsList.removeAll()
        timeSlotSelectedIndex = 0
        if let add_id = self.selected_address_id {
            self.fetchCustomerAddressDetails(address_id: add_id)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        DispatchQueue.main.async {
        self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    
    @objc func payNowbtnAction(sender : UIButton) {
        
        let slot = self.wholeDict["timeslot_list"] as? [[String : Any]]
        var slotTitle  = ""
        
        if isSelected == true {
            useWalletBalance = 1
        }else{
            useWalletBalance = 0
        }
        if slot?.count ?? 0 > 0 {
            slotTitle = slot?[timeSlotSelectedIndex ?? 0]["name"] as! String
            self.initiateOrder(slotTitle: slotTitle)
        }
    }
    
    func initiateOrder(slotTitle : String) {
        Loader.showHud()
        
        ServiceClient.sendRequestPOSTBearer(apiUrl:APIEndPoints.shared.INITIATE_ORDER , postdatadictionary: ["time_slot":"\(slotTitle )"], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String : Any] {
                        let order_id = data["order_id"] as? Int
                        self.initiatePayment(order_id: "\(order_id ?? 0)")
                    }
                }
            }
        }
    }
    
    
    func initiatePayment(order_id : String) {
        Loader.showHud()
        
        ServiceClient.sendRequestPOSTBearer(apiUrl:"\(APIEndPoints.shared.INITIATE_PAYMENT)/\(order_id)" , postdatadictionary: ["use_balance":"\(useWalletBalance ?? 0)"], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if self.useWalletBalance == 1 {
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        
                    }else{
                        if let data = res["data"] as? [String : Any] {
                            let payStr = (data["total"] ?? "0")
                            let razorpay_order_id = (data["razorpay_order_id"] ?? "0")
                            
                            DispatchQueue.main.async {
                                self.tblView.reloadData()
                                self.pay.addMoneyToPay(amount: "\(payStr)", payOrderid: "\(razorpay_order_id)", screen: "cart")
                            }
                        }
                    }

                }else{
                    
                }
            }
        }
    }
        
    
    
    func fetchCustomerAddressDetails( address_id : String) {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.GET_PAYMENT_INFO)/\(address_id )" , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String : Any] {
                        self.wholeDict = data
                        print(self.wholeDict)
                        if let itemdetails = self.wholeDict["itemdetails"] as? [[String : Any]] {
                            self.itemdetailsList.removeAll()
                            self.itemdetailsList = itemdetails
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



extension PaymentDetailsViewController : UITableViewDelegate, UITableViewDataSource {
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.itemdetailsList.count
        }
        else if section == 3 {
            return 5
        }
        
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "CouponCell") as? CouponCell
        
        
        if indexPath.section == 0 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailItemCell") as? DetailItemCell
            
            let dict = self.itemdetailsList[indexPath.row]
            let name = dict["name"] as? String
            let size = dict["size"] as? String
            let mrp = dict["price"] as? String
            let cutPrice = dict["cut_price"] as? String
            let image = dict["image"] as? String
            let company = dict["company"] as? String

            
            cell?.namelbl.text = "\(name ?? "") (\(company ?? ""))"
            cell?.sizeLbl.text = "Size : \(size ?? "")"
            cell?.mrpLbl.text = "MRP : \(cutPrice ?? "")"
            cell?.cutPriceLbl.text = "\(StringConstant.RupeeSymbol)\(mrp ?? "0")"

            let urlString  =  image
            cell?.itemImg.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            
            
            return cell!
        }
        else if indexPath.section == 1 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "TimeSlotCell") as? TimeSlotCell
            cell?.topHeaderlbl.text = "Choose Time Slot"

            let slot = self.wholeDict["timeslot_list"] as? [[String : Any]]
            cell?.field.text = ""

            if slot?.count ?? 0 > 0 {
                let slotName = slot?[timeSlotSelectedIndex ?? 0]["name"]
                cell?.field.text = "\(slotName ?? "")"
            }

            return cell!
        }
        else if indexPath.section == 2 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailAddressCell") as? DetailAddressCell
            let delivery_address = self.wholeDict["delivery_address"] as? [String : Any]
            let house_no = delivery_address?["house_no"] as? String
            let street = delivery_address?["street"] as? String
            let city = delivery_address?["city"] as? String
            let area = delivery_address?["area"] as? String
            let pincode = delivery_address?["pincode"] as? String
            let mobile_no = delivery_address?["mobile_no"] as? String

            cell?.topHeaderlbl.text = "DELIVERY ADDRESS"
            cell?.l1lbl.text =  "H.no. \(house_no ?? "") \(street ?? "")"
            cell?.l2lbl.text =  "\(area ?? "") \(city ?? "")"
            cell?.l3lbl.text =  "Pincode: \(pincode ?? "")\nMob:\(mobile_no ?? "")"

            return cell!
        }
        
        else if indexPath.section == 3 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailPriceCell") as? DetailPriceCell
            
            let priceDict = self.wholeDict["prices"] as? [String : Any]
            let basket_total = priceDict?["basket_total"] as? Int
            let delivery_charge = priceDict?["delivery_charge"] as? String
            let coupon_discount = priceDict?["coupon_discount"] as? Int
            let total_savings = priceDict?["total_savings"] as? Int
            let total_payble = priceDict?["total_payble"] as? Int
            
            if indexPath.row == 0{
                cell?.l1lbl.text = "Basket Value"
                cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(basket_total ?? 0)"

            }
            else if indexPath.row == 1{
                cell?.l1lbl.text = "Delivery Charge"
                cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(delivery_charge ?? "00")"

            }
            else if indexPath.row == 2{
                cell?.l1lbl.text = "Coupon Discount"
                cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(coupon_discount ?? 0)"

            }
            else if indexPath.row == 3{
                cell?.l1lbl.text = "Total amount payable"
                cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(total_payble ?? 0)"

            }
            else if indexPath.row == 4{
                cell?.l1lbl.text = "Total Saving"
                cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(total_savings ?? 0)"

            }
            
            return cell!
        }
        
        else if indexPath.section == 4 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "CouponCell") as? CouponCell
            cell?.couponfield.placeholder = "Enter Coupon Code"

            return cell!
        }
        
        else if indexPath.section == 5 {
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "DetailWalletCell") as? DetailWalletCell
            cell?.l1lbl.text = "Use Wallet Balance"
            let wallet_balance = self.wholeDict["wallet_balance"]

            
            cell?.costlbl.text = "\(StringConstant.RupeeSymbol) \(wallet_balance ?? 0)"
            if isSelected == true {
                cell?.itemImg.image = UIImage(named: "radioselected")
            }else{
                cell?.itemImg.image = UIImage(named: "radioUnselected")
            }
            
            return cell!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 || indexPath.section == 4 {
            return 60

        }
        if indexPath.section == 5 {
            return 100
        }
        
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 5 {
            isSelected =  !(isSelected ?? false)
            self.tblView.reloadData()
        }
    }
    
    
}
