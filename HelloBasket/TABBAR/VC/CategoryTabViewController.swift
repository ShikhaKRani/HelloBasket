//
//  CategoryTabViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 07/10/20.
//


import UIKit
import SDWebImage

class CategoryTabViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var navigationView: UIView!

    var categoryData =  [CategoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationView.backgroundColor = AppColor.themeColor

        tblView.tableFooterView = UIView()
        self.fetchCategoryData()
    }
    
    func fetchCategoryData() {
        
        // let param: [String: Any] = ["name": "Shikha"]
        Loader.showHud()
        ServiceClient.getProductCategory(parameters: [:]) { [weak self] result in
            Loader.dismissHud()
            switch result {
            case let .success(response):
                if let catData = result.response?.data {
                    self?.categoryData = catData
                    print(response)
                    DispatchQueue.main.async {
                        self?.tblView.reloadData()
                    }
                }
            case .failure: break
            }
        }
    }
    
    
    @objc func toggleCollapse(sender: UIButton) {
        
        let section = sender.tag
        let collapsed = self.categoryData[section].isTapped
        // Toggle collapse
        self.categoryData[section].isTapped = !(collapsed ?? false)
        tblView.reloadData()
    }
    
}

//MARK:- Delegate and Datasource

extension CategoryTabViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.categoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = self.categoryData[section].subcategory?.count
        if self.categoryData[section].isTapped ?? false {
            return rowCount ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "HeaderCell") as? HeaderCell
        cell?.toggleBtn.tag = section
        cell?.toggleBtn.addTarget(self, action: #selector(toggleCollapse(sender:)), for: .touchUpInside)
        cell?.titleLbl.text = self.categoryData[section].name
        let urlString = self.categoryData[section].image ?? ""
        cell?.img.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder.png"))
        
        // istapped 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell
        let title = self.categoryData[indexPath.section].subcategory?[indexPath.row].name
        cell?.titleLbl.text = title
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK:- Side Menu Set up
extension CategoryTabViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as?
                SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = Utils.makeSettings()
    }
}
//MARK:- Side Menu Set up


//MARK:- Cell

class HeaderCell : UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var toggleBtn: UIButton!
    
}

class CategoryCell : UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
}

