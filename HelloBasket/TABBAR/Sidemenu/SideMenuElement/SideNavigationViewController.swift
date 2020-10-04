//
//  SideNavigationViewController.swift
//  EDXPERT
//
//  Created by Vibhash Kumar on 16/07/19.
//  Copyright © 2019 Vibhash Kumar. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
class SideNavigationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var profileImgIcon: UIImageView!
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sideMenuTablevw: UITableView!
    @IBOutlet weak var sideMenuView: UIView!
    
    @IBOutlet weak var preficProfileLbl: UILabel!
    @IBOutlet weak var selectedProfileLbl: UILabel!
    @IBOutlet weak var selectedProfileSubTitleLbl: UILabel!
    
    @IBOutlet weak var unselectedProfileBtn: UIButton!
    
    let dropDown = DropDown()
    
    let  cellReuseIdentifier = "sideMenuTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sideMenuView.layer.cornerRadius = 20
        self.sideMenuView.layer.masksToBounds = true
        self.sideMenuTablevw.backgroundColor = .tertiarySystemGroupedBackground
//        self.selectedProfileLbl.text = "\(userName.prefix(18))"
//        self.selectedProfileSubTitleLbl.text = "Class : \(classStd) \(section)"
        
//        if nameArr.count>1{
//
//            let firstName = (String(nameArr[0])).prefix(1)
//            let lastName = (String(nameArr[1])).prefix(1)
//            self.preficProfileLbl.text = "\(firstName+lastName)"
//        }else{
//            self.preficProfileLbl.text = "\((nameArr.first ?? "").prefix(1))"
//        }
        
        
        sideMenuTablevw.delegate = self
        sideMenuTablevw.dataSource = self
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // updateProfilePic()
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1

        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: sideMenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? sideMenuTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "sideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "sideMenuTableViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuTableViewCell") as? sideMenuTableViewCell
        }
        
        
        return cell!
    }
    
}
