//
//  OrderHistoryViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 02/11/20.
//

import UIKit

class OrderhistoryCell : UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderlbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var viewdetailLbl: UILabel!
    @IBOutlet weak var img: UIImageView!

}

class OrderHistoryViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    var orderList : [[String: Any]] = [[:]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Order History"
        
        self.fetchOrderHistory()
        
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    
    func fetchOrderHistory() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:(APIEndPoints.shared.ORDER_HISTORY) , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [[String: Any]] {
                        print(data)
                        self.orderList.removeAll()
                        for item in data {
                            self.orderList.append(item)
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
    


extension OrderHistoryViewController : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "OrderhistoryCell") as? OrderhistoryCell
        
        let order = self.orderList[indexPath.row]

        
        cell?.viewdetailLbl.layer.borderColor = UIColor.gray.cgColor
        cell?.viewdetailLbl.layer.borderWidth = 1
        cell?.viewdetailLbl.layer.cornerRadius = 2
        
        cell?.nameLbl.text = order["title"] as? String
        cell?.orderlbl.text = order["booking_id"] as? String
        cell?.dateLbl.text = order["datetime"] as? String
        let price = order["total_price"] as? String
        cell?.pricelbl.text = "\(StringConstant.RupeeSymbol)\(price ?? "0")"

        let urlString  =  order["image"] as? String
        cell?.img.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)

        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let order = self.orderList[indexPath.row]
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let orderVC = storyBoard.instantiateViewController(withIdentifier: "OrderDetaiViewController") as? OrderDetaiViewController {
            let orderid = order["id"] as? Int
            orderVC.orderId =  "\(orderid ?? 0)"
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
    }
    
}
