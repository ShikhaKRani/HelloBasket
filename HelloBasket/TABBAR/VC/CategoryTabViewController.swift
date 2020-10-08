//
//  CategoryTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//


import UIKit

class HeaderCell : UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
}

class CategoryCell : UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    
}



class CategoryTabViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var dataArr : Array<Dictionary<String,AnyObject>> = [
        ["title":"Fruits" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"Beverages" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"Beauty" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"Personal" as AnyObject,"image": "profile" as AnyObject]
        ,["title":"Cleaning" as AnyObject,"image": "profile" as AnyObject]
         ,["title":"Eggs" as AnyObject,"image": "profile" as AnyObject]]

    
}


extension CategoryTabViewController {
    
    //MARK:- Side Menu Set up
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
            SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
    
    //MARK:- Side Menu Set up
}

extension CategoryTabViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        6
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell
        
        let cellDict = dataArr[section] as Dictionary<String,AnyObject>
       cell?.img.image = UIImage.init(named: cellDict["image"] as? String ?? "")
       cell?.titleLbl.text = cellDict["title"] as? String ?? ""
       //cell?.selectionStyle  = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell
        
        
        
//        if indexPath.section == 1{
//            let cell = self.tblView.dequeueReusableCell(withIdentifier: "imgCell") as? sideMenuTableViewCell
        
            
            
            return cell!
            
        }
        
        
}

    
    






//tableview create
// number of section according to array
//view for header in section view uspe aisa UI


/*
 
 numberofsection array count
 
 6 header
 
 //number of row in section 1
 override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 
 let imgitem = array[section]
 let titleitem = array[section]

 let cell = tblview.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell
cell.titlelb.text = titleitem
 cell.img.image = imgitem

 
     return cell
 }

 override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 75
 }
 
 header
 row
 header
 row
 
 number of row in section
 return 1
 
 cellforrow {
 //CategoryCell
 title "shikha"
 }
 
 **/
