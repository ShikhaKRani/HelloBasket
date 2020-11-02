//
//  ComplaintViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 26/10/20.
//

import UIKit

class ComplaintTableViewCell : UITableViewCell{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var complaintIDLabel: UILabel!
    @IBOutlet weak var complaintMsgLabel: UILabel!
    @IBOutlet weak var complaintTimeLabel: UILabel!
}

class ComplaintViewController: UIViewController {
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var complaintTableView: UITableView!
    var complaintList : [[String: Any]] = [[:]]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComplaintList()

        
    }
    
    func fetchComplaintList() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:(APIEndPoints.shared.COMPLAINT_LIST) , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String: Any] {
                        if let complaints = data["complaints"] as? [[String: Any]] {
                            self.complaintList.removeAll()

                            for item in complaints {
                                self.complaintList.append(item)
                            }
                        
                        
                        }
                    }
                    DispatchQueue.main.async {
                        self.complaintTableView.reloadData()
                    }
                }
            }
        }
    }
}
    
    

    



extension ComplaintViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.complaintList.count
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.complaintTableView.dequeueReusableCell(withIdentifier: "ComplaintTableViewCell") as? ComplaintTableViewCell
        let complaint = self.complaintList[indexPath.row]
        
        cell?.complaintIDLabel.text = complaint["refid"] as? String
        cell?.complaintMsgLabel.text = complaint["subject"] as? String
        cell?.complaintTimeLabel.text = complaint["created_at"] as? String

        //cell?.complaintIDLabel.text =
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    
    }


}
