//
//  NotificationViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 02/11/20.
//

import UIKit


class NotificationCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
}

class NotificationViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    var notificationList : [[String: Any]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Notifications"
        
        self.fetchNotificationList()
        
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    
    func fetchNotificationList() {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:(APIEndPoints.shared.NOTIFICATIONS) , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let data = res["data"] as? [String: Any] {
                        if let notifications = data["notifications"] as? [[String: Any]] {
                            self.notificationList.removeAll()

                            for item in notifications {
                                self.notificationList.append(item)
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
    
    
}

extension NotificationViewController : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell
        
        let notification = self.notificationList[indexPath.section]
        cell?.title.text = notification["title"] as? String
        cell?.subtitle.text = notification["description"] as? String
        return cell!
    }
    
    
}
