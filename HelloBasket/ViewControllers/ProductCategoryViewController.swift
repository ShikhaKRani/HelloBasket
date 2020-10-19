//
//  ProductCategoryViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 11/10/20.
//

import UIKit

class SubCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
}

class ProductCategoryViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var totalItemslbl: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    var prevDict : [String: Any]?
    var catId : String?
    var screen : String?
    
    var prodcutCategory : ProdcutListCategory?
    var wholeProductList = [ProductModel]()
    
    var selectedRowCollection : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Product Category"
        
        self.totalItemslbl.text = ""
        if screen == "home" {
            if let cat_id = prevDict?["cat_Id"] {
                catId = "\(cat_id )"
                print(cat_id)
                self.fetchSubCategoryForProductList()
                self.fetchProductList(categoryId: "\(catId ?? "0")")
            }
        }
        else{
            
        }
        
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    func registerCell() {
        tblView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    
    func fetchProductList(categoryId : String) {
        var param: [String: Any] = [:]
        param = ["category_id" : categoryId]
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.PRODUCT_LIST, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let productDict = res["data"] as? [String : Any] {
                        if let productList = productDict["data"] as? [[String : Any]] {
                            self.wholeProductList.removeAll()
                            for item in productList {
                                let model = ProductModel(dict: item)
                                self.wholeProductList.append(model)
                            }
                            
                            DispatchQueue.main.async {
                                if self.wholeProductList.count > 1 {
                                    self.totalItemslbl.text = "\(self.wholeProductList.count) Items"
                                    
                                }else{
                                    self.totalItemslbl.text = "\(self.wholeProductList.count) Item"
                                    
                                }
                                self.tblView.reloadData()
                                self.collectionView.reloadData()
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    //Pagination // append
    func fetchNextProductCategory(categoryId : String) {
        var param: [String: Any] = [:]
        param = ["category_id" : categoryId]
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.PRODUCT_LIST, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    if let productDict = res["data"] as? [String : Any] {
                        if let productList = productDict["data"] as? [[String : Any]] {
                            for item in productList {
                                let model = ProductModel(dict: item)
                                self.wholeProductList.append(model)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchSubCategoryForProductList() {
        
        let cat = self.catId
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.SUBCATEGORY_LIST)/\(cat ?? "0")" , postdatadictionary: [:], isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    self.prodcutCategory = ProdcutListCategory(dict: res)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @objc func dropdownBtnAction(sender : UIButton) {
        
        let model =  self.wholeProductList[sender.tag]
        print(model.sizeprice.count)
        
        if model.sizeprice.count > 1 {
            
            // code
            
            
        }
        
    }
    
    //MARK:-
    @objc func plusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        
        let model =  self.wholeProductList[sender.tag]
        var count = model.itemSelected ?? 0
        
        //        if model.max_qty ?? 0 > 0 {
        count = count + 1
        model.itemSelected =  count
        cell?.itemCountLbl.text = "\(model.itemSelected ?? 0)"
        model.itemSelected = count
        
        //            self.addProductToCart(model: model,tag: sender.tag)
        //        }
        
        if count == 0 {
            cell?.plusBtn.isHidden = true
            cell?.minusBtn.isHidden = true
            cell?.itemCountLbl.isHidden = true
            cell?.AddFirstBtn.isHidden = false
            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.plusBtn.isHidden = false
            cell?.minusBtn.isHidden = false
            cell?.itemCountLbl.isHidden = false
            cell?.AddFirstBtn.isHidden = true
            cell?.addFirstTopConstraint.constant = 100
        }
        
        
        
    }
    
    
    @objc func addFirstBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        let model =  self.wholeProductList[sender.tag]
        var count = model.itemSelected ?? 0
        
        //        if model.max_qty ?? 0 > 0 {
        //            if count < model.max_qty ?? 0  {
        count = count + 1
        model.itemSelected =  count
        cell?.itemCountLbl.text = "\(model.itemSelected ?? 0)"
        model.itemSelected = count
        
        
        //            self.addProductToCart(model: model,tag: sender.tag)
        //        }
        
        if count == 0 {
            cell?.plusBtn.isHidden = true
            cell?.minusBtn.isHidden = true
            cell?.itemCountLbl.isHidden = true
            cell?.AddFirstBtn.isHidden = false
            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.plusBtn.isHidden = false
            cell?.minusBtn.isHidden = false
            cell?.itemCountLbl.isHidden = false
            cell?.AddFirstBtn.isHidden = true
            cell?.addFirstTopConstraint.constant = 100
        }
        
    }
    
    @objc func minusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        
        let model =  self.wholeProductList[sender.tag]
        var count = model.itemSelected ?? 0
        
        if count > 0 {
            count = count - 1
            model.itemSelected =  count
            
            cell?.itemCountLbl.text = "\(model.itemSelected ?? 0)"
            model.itemSelected = count
            
            //            self.addProductToCart(model: model,tag: sender.tag)
        }
        
        if count == 0 {
            cell?.plusBtn.isHidden = true
            cell?.minusBtn.isHidden = true
            cell?.itemCountLbl.isHidden = true
            cell?.AddFirstBtn.isHidden = false
            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.plusBtn.isHidden = false
            cell?.minusBtn.isHidden = false
            cell?.itemCountLbl.isHidden = false
            cell?.AddFirstBtn.isHidden = true
            cell?.addFirstTopConstraint.constant = 100
        }
    }
        
}

extension ProductCategoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wholeProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell
        
        let model =  self.wholeProductList[indexPath.row]
        cell?.dropDownBtn.tag = indexPath.row
        cell?.dropDownBtn.addTarget(self, action: #selector(dropdownBtnAction(sender:)), for: .touchUpInside)
        
        cell?.AddFirstBtn.layer.cornerRadius = 5
        cell?.AddFirstBtn.layer.masksToBounds = true
        cell?.plusBtn.tag = indexPath.row
        cell?.AddFirstBtn.tag = indexPath.row
        cell?.minusBtn.tag = indexPath.row
        
        cell?.plusBtn.addTarget(self, action: #selector(plusBtnAction(sender:)), for: .touchUpInside)
        cell?.AddFirstBtn.addTarget(self, action: #selector(addFirstBtnAction(sender:)), for: .touchUpInside)
        cell?.minusBtn.addTarget(self, action: #selector(minusBtnAction(sender:)), for: .touchUpInside)
        
        cell?.title.text = model.name?.capitalized ?? ""
        cell?.companyLbl.text = model.company?.capitalized ?? ""
        cell?.ratingLbl.text = "\(model.ratings ?? "") \(StringConstant.StarSymbol)"
        cell?.ratingLbl.textColor = AppColor.themeColor
        
        
        if model.sizeprice.count > 0 {
            let mod = model.sizeprice[0]
            cell?.priceSale.text = "Price: \(StringConstant.RupeeSymbol)\(mod.price ?? 0)"
            cell?.priceCut.text = "MRP: \(StringConstant.RupeeSymbol)\(mod.cut_price ?? 0)"
            cell?.quantityField.text = "\(mod.size?.capitalized ?? "")"
            let urlString  =  mod.image
            cell?.titleImg.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)            
        
            cell?.offerlbl.text = "\(mod.discount ?? 0)%"

        
        }
        cell?.dropDownBtnImg.isHidden = true
        if model.sizeprice.count > 1 {
            cell?.dropDownBtnImg.isHidden = false
        }
        
        // add func
        if model.itemSelected ?? 0 > 0 {
            cell?.addFirstTopConstraint.constant = 100
            cell?.AddFirstBtn.isHidden = true
            cell?.plusBtn.isHidden = false
            cell?.minusBtn.isHidden = false
            cell?.itemCountLbl.isHidden = false
        }
        else{
            cell?.addFirstTopConstraint.constant = 22.5
            cell?.AddFirstBtn.isHidden = false
            cell?.plusBtn.isHidden = true
            cell?.minusBtn.isHidden = true
            cell?.itemCountLbl.isHidden = true
        }
        
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  186
    }
}




extension ProductCategoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prodcutCategory?.categoryData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath as IndexPath) as! SubCategoryCollectionViewCell
        cell.titleLbl.backgroundColor = .white
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.titleLbl.layer.cornerRadius = 5
        cell.titleLbl.layer.masksToBounds = true
        
        let cat = self.prodcutCategory?.categoryData[indexPath.row]
        cell.titleLbl.text = cat?.name?.capitalized ?? ""
        if indexPath.row == self.selectedRowCollection {
            cell.titleLbl.textColor = .red
            cell.titleLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
        else{
            cell.titleLbl.textColor = .black
            cell.titleLbl.font = UIFont.systemFont(ofSize: 15)
        }
        
        return cell
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cat = self.prodcutCategory?.categoryData[indexPath.row]
        self.selectedRowCollection = indexPath.row
        self.fetchProductList(categoryId: "\(cat?.cat_id ?? 0)")
        
    }
    
}
