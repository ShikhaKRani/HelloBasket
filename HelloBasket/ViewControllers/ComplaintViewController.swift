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

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    

}

extension ComplaintViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.complaintTableView.dequeueReusableCell(withIdentifier: "ComplaintTableViewCell") as? ComplaintTableViewCell
        
        return cell!
    }


}
