//
//  SearchViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 12/11/20.
//

import UIKit
import DropDown

class SearchViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!

    var searchedString : String?
    var wholeProductList = [ProductModel]()
    let dropDown = DropDown();

    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        self.tblView.tableFooterView = UIView()
        searchedString = ""
        searchField.delegate = self
        searchField.autocorrectionType = .no
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(searchbtnAction), for: .touchUpInside)

        self.navTitle.text = "Search Product"
        headerView.backgroundColor = AppColor.themeColor

        
        //     http://hallobasket.appoffice.xyz/api/search-products?search=hea

    }
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }

    func registerCell() {
        tblView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    
    @objc func searchbtnAction() {
        self.view.endEditing(true)
        if searchedString?.count ?? 0 > 0 {
            self.searchProduct(searchString: searchedString ?? "")
        }else{
            self.view.makeToast("\("Please enter")", duration: 3.0, position: .bottom)
        }
    }
    
    func searchProduct(searchString : String) {
        
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl:"\(APIEndPoints.shared.SEARCH_PRODUCT)?search=\(searchedString ?? "")" , postdatadictionary: [:], isArray: false) { (response) in
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
                                self.tblView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func dropdownBtnAction(sender : UIButton) {
        
        let model =  self.wholeProductList[sender.tag]
        let cell = sender.superview?.superview?.superview as? ProductCell
        print(model.sizeprice.count)
        if model.sizeprice.count > 1 {
            var sizeList = [String]()
            for item in model.sizeprice {
                let size = item.size
                sizeList.append(size ?? "")
            }
            print(sizeList)
            self.dropDown.anchorView = cell?.dropDownBtn.plainView
            self.dropDown.bottomOffset = CGPoint(x: 0, y: (sender).bounds.height)
            self.dropDown.dataSource.removeAll()
            self.dropDown.dataSource = sizeList
            self.dropDown.selectionAction = { [unowned self] (index, item) in
                print(item)
                cell?.quantityField.text = item
                model.sizeItemNumber = index
            }
            self.dropDown.show()
        }
    }
    
    //MARK:-
    @objc func plusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview?.superview as? ProductCell
        
        let model =  self.wholeProductList[sender.tag]
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
                
                if count > model.sizeprice[sizeNum].max_qty ?? 0 {
                    count = model.sizeprice[sizeNum].max_qty ?? 0
                    model.sizeprice[sizeNum].quantity = count
                }
                
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
        let model =  self.wholeProductList[sender.tag]
        var count = 0
        
        let sizeNum = model.sizeItemNumber ?? 0

        if model.sizeprice.count >= sizeNum {

            count = model.sizeprice[sizeNum].quantity ?? 0
            if model.sizeprice[sizeNum].min_qty ?? 0 > 0 {
                count = model.sizeprice[sizeNum].min_qty ?? 0
                model.itemSelected = count
                model.sizeprice[sizeNum].quantity = count
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
        
        let model =  self.wholeProductList[sender.tag]
        let sizeNum = model.sizeItemNumber ?? 0
        let lblcount = model.sizeprice[sizeNum].quantity
        var count = lblcount ?? 0
        if model.sizeprice[sizeNum].min_qty ?? 0 > 0 {
            if model.itemSelected ?? 0 > 0 {
                count = model.itemSelected ?? 0
            }
            count = count - 1
            model.itemSelected =  count
            if model.itemSelected ?? 0 < model.sizeprice[sizeNum].min_qty ?? 0 {
                count = 0
                model.itemSelected = 0
            }
            self.addProductToCart(model: model, tag: sender.tag)
            model.sizeprice[sizeNum].quantity = count
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
    
    @objc func addFavoriteBtnAction(sender : UIButton) {
        
        let model =  self.wholeProductList[sender.tag]
        print(model.sizeprice.count)
        
        self.addFovoriteProduct(model: model, tag: sender.tag)
        
    }
    
    func addFovoriteProduct(model : ProductModel, tag : Int) {
        var param: [String: Any] = [:]
        param = ["product_id" : "\(model.product_id ?? 1)"]
        Loader.showHud()
        print(UserDetails.shared.getAccessToken())
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.ADD_FAVORITE, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    print(res["message"] ?? "")
                    DispatchQueue.main.async {
                        model.isfavourite = true
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                }else{
                    DispatchQueue.main.async {
                        model.isfavourite = false
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                }
            }
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
                let msg = res["message"] as? String
                if res["status"] as? String == "success" {
                    DispatchQueue.main.async {
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                }else{
                    
                    let model = model
                    let mod = model.sizeprice[sizeNum]
                    if model.itemSelected ?? 0 <  mod.min_qty ?? 0{
                        model.itemSelected = 0
                        mod.quantity = 0
                        
                        // remove from cart
                    }
                    
                    if model.itemSelected ?? 0 > mod.max_qty ?? 0 {
                        model.itemSelected = mod.max_qty
                        mod.quantity = mod.max_qty
                    }
                    
                    
                    if mod.in_stocks ?? 0 > 0 {
                        model.itemSelected = mod.quantity
                    }else{
                        
                        model.itemSelected = 0
                        mod.quantity = 0
                    }
                    
                    //alert
                    DispatchQueue.main.async {
                        self.view.makeToast("\(msg ?? "")", duration: 3.0, position: .bottom)
                        self.tblView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
                    }
                    
                }
            }
        }
        
    }
    
}


extension SearchViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchedString = textField.text
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
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

        if (model.isfavourite ?? false) {
            cell?.likeBtn.setBackgroundImage(UIImage(named: "favRed"), for: .normal)
        }else{
            cell?.likeBtn.setBackgroundImage(UIImage(named: "favGrey"), for: .normal)
        }

        let sizeNum = model.sizeItemNumber ?? 0


        if model.sizeprice.count > 0 {
            let mod = model.sizeprice[sizeNum]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model =  self.wholeProductList[indexPath.row]
        let sizeNum = model.sizeItemNumber ?? 0
        let mod = model.sizeprice[sizeNum]

        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)

            if let detail = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController {
                if let cat_id = mod.product_id {
                    detail.product_id = "\(cat_id )"
                    print(cat_id)
                    detail.screen = "home"
                    self.navigationController?.pushViewController(detail, animated: true)
                }
            }
    }
    
}
