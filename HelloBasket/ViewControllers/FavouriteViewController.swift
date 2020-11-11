//
//  FavouriteViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 24/10/20.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var tblView: UITableView!
    
    
    
    var productList = [ProductModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        self.tblView.tableFooterView = UIView()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Favourite Product"
        
        self.fetchFavouriteProductData()
        
    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    func registerCell() {
        tblView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    
    
    func fetchFavouriteProductData() {
        
        let param: [String: Any] = [:]
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl: APIEndPoints.shared.GET_FAVOURITE_LIST, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if let prod = res["favoriteproduct"] as? [[String : Any]] {
                    print(prod)
                    self.productList.removeAll()
                    for item in prod {
                        let model = ProductModel(dict: item)
                        self.productList.append(model)
                    }
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    func deleteFovoriteProduct(model : ProductModel, tag : Int) {
        var param: [String: Any] = [:]
        
        param = ["product_id" : "\(model.product_id ?? 1)"]
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.DELETE_FAVOURITE_LIST, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    print(res["message"] ?? "")
                    self.fetchFavouriteProductData()
                }else{
                }
            }
        }
    }
    
    
    //MARK:-
    //MARK:-     //Button Action
    
    @objc func addFavoriteBtnAction(sender : UIButton) {
        
        let model =  self.productList[sender.tag]
        print(model.sizeprice.count)
        self.deleteFovoriteProduct(model: model, tag: sender.tag)
    }
    
    
    @objc func dropdownBtnAction(sender : UIButton) {
        let model =  self.productList[sender.tag]
        print(model.sizeprice.count)
        if model.sizeprice.count > 1 {
            // code
            
        }
    }
    
    //MARK:-
    @objc func plusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        let model =  self.productList[sender.tag]
        var count = 0
        let sizeNum = model.sizeItemNumber ?? 0
        if model.sizeprice.count >= sizeNum {
            count = model.sizeprice[sizeNum].quantity ?? 0
            if model.sizeprice[sizeNum].min_qty ?? 0 > 0 {
                
                let mod = model.sizeprice[sizeNum]
                if mod.stock ?? 0 <  model.itemSelected ?? 0 {
                    model.itemSelected = mod.stock
                }
                count = model.sizeprice[sizeNum].quantity ?? 0
                if model.itemSelected ?? 0 > 0 {
                    count = model.itemSelected ?? 0
                }
                count = count + 1
                model.itemSelected = count
            }
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
        self.addProductToCart(model: model, tag: sender.tag)
    }
    
    
    
    @objc func addFirstBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        let model =  self.productList[sender.tag]
        var count = 0
        let sizeNum = model.sizeItemNumber ?? 0
        if model.sizeprice.count >= sizeNum {
            count = model.sizeprice[sizeNum].quantity ?? 0
            //min quantity
            if model.sizeprice[sizeNum].min_qty ?? 0 > 0 {
                count = model.sizeprice[sizeNum].min_qty ?? 0
                model.itemSelected = count
            }
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
        
        self.addProductToCart(model: model, tag: sender.tag)
        
    }
    
    @objc func minusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        
        let model =  self.productList[sender.tag]
        let sizeNum = model.sizeItemNumber ?? 0
        let lblcount = model.sizeprice[sizeNum].quantity
        var count = lblcount ?? 0
        
        if model.itemSelected ?? 0 > 0 {
            count = model.itemSelected ?? 0
        }
        
        
        if count > 0 {
            count = count - 1
            model.itemSelected =  count
            self.addProductToCart(model: model, tag: sender.tag)
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
    
    
    func addProductToCart(model :ProductModel, tag : Int) {
        //        ADD_CART
        //product_id
        //size_id
        //quantity
        let sizeNum = model.sizeItemNumber ?? 0
        var productSizeId = 0
        if model.sizeprice.count > 0 {
            productSizeId = model.sizeprice[sizeNum].productSize_id ?? 0
        }
        var param: [String: Any] = [:]
        param = ["quantity" : "\(model.itemSelected ?? 0)","product_id" : "\(model.product_id ?? 0)","size_id" : productSizeId]
        
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.ADD_CART, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    DispatchQueue.main.async {
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                }else{
                    
                    let model = model
                    let mod = model.sizeprice[sizeNum]
                    if mod.in_stocks ?? 0 > 0 {
                        model.itemSelected = mod.quantity
                    }else{
                        model.itemSelected = 0
                    }
                    
                    //alert
                    print(res["message"] ?? "")
                    DispatchQueue.main.async {
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                    
                }
            }
        }
        
    }
    
    
    
    
}

extension FavouriteViewController : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as? ProductCell
        
        let model =  self.productList[indexPath.row]
        cell?.dropDownBtn.tag = indexPath.row
        cell?.dropDownBtn.addTarget(self, action: #selector(dropdownBtnAction(sender:)), for: .touchUpInside)
        
        cell?.AddFirstBtn.layer.cornerRadius = 5
        cell?.AddFirstBtn.layer.masksToBounds = true
        
        cell?.plusBtn.tag = indexPath.row
        cell?.AddFirstBtn.tag = indexPath.row
        cell?.minusBtn.tag = indexPath.row
        cell?.likeBtn.tag = indexPath.row
        
        cell?.plusBtn.addTarget(self, action: #selector(plusBtnAction(sender:)), for: .touchUpInside)
        cell?.AddFirstBtn.addTarget(self, action: #selector(addFirstBtnAction(sender:)), for: .touchUpInside)
        cell?.minusBtn.addTarget(self, action: #selector(minusBtnAction(sender:)), for: .touchUpInside)
        cell?.likeBtn.addTarget(self, action: #selector(addFavoriteBtnAction(sender:)), for: .touchUpInside)
        
        cell?.title.text = model.name?.capitalized ?? ""
        cell?.companyLbl.text = model.company?.capitalized ?? ""
        cell?.ratingLbl.text = "\(model.ratings ?? "") \(StringConstant.StarSymbol)"
        cell?.ratingLbl.textColor = AppColor.themeColor
        
        cell?.dropDownBtnImg.isHidden = true
        if model.sizeprice.count > 1 {
            cell?.dropDownBtnImg.isHidden = false
        }
        
        cell?.likeBtn.setBackgroundImage(UIImage(named: "trashIcon.png"), for: .normal)
        cell?.likeBtn.tintColor = AppColor.themeColorSecond
        
        if model.sizeprice.count > 0 {
            let mod = model.sizeprice[0]
            cell?.priceSale.text = "Price: \(StringConstant.RupeeSymbol)\(mod.price ?? "0")"
            cell?.priceCut.text = "MRP: \(StringConstant.RupeeSymbol)\(mod.cut_price ?? "0")"
            cell?.quantityField.text = "\(mod.size?.capitalized ?? "")"
            let urlString  =  mod.image
            cell?.titleImg.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            
            cell?.offerlbl.text = "\(mod.discount ?? 0)%"
            
            if model.itemSelected ?? 0 > 0 {
                cell?.itemCountLbl.text = "\(model.itemSelected ?? 0)"
                
            }else{
                cell?.itemCountLbl.text = "\(mod.quantity ?? 0)"
                
            }
            
            // add func
            if mod.quantity ?? 0 > 0 {
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
            
        }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  186
    }
}
