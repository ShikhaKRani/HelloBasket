//
//  HomeViewController-Ext.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 11/10/20.
//

import Foundation
import UIKit


//MARK:- BANNER
class ImageBannerCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: BJAutoScrollingCollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var line2: UILabel!
    
    var bannerArray = [[String: Any]]()
    var screen : String?
    func configureCell(imgData:[[String: Any]], screen : String?) {
        bannerArray = imgData
        self.screen = screen
        
        if screen == "top" {
            line1.isHidden = true
            line2.isHidden = true
        }
        else{
            line1.isHidden = false
            line2.isHidden = false
        }
        
        initCollectionView()
        scrollReload()
    }
    
    func initCollectionView() {
        self.collectionView.scrollInterval = 2 //Step 2
        self.collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionViewFlowLayout.minimumInteritemSpacing = 0
        self.collectionViewFlowLayout.minimumLineSpacing = 0
    }
    
    func scrollReload() {
        self.collectionView.reloadData()
        self.collectionView.startScrolling() //Step 3
    }
}


extension ImageBannerCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ImageCollectionViewCell.self)", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imgDict = self.bannerArray[indexPath.row]
        let urlString  =  imgDict["image"] as? String
        cell.cellImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imgDict = self.bannerArray[indexPath.row]
        var cat_id = 0
        if screen == "top" {
            cat_id = imgDict["cat_id"] as? Int ?? 0
        }else{
            cat_id = imgDict["category_id"] as? Int ?? 0
        }
        
        print("===>>> ",cat_id )
        NotificationCenter.default.post(name: Notification.Name("NotificationHomeIdentifier"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
        
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellImage.contentMode = .scaleToFill
    }
}
//MARK:- BANNER END


//MARK:- Categories

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    
    var categories =  [[String : Any]]()
    var subCategories =  [[String : Any]]()
    
    var screen = ""
    
    func configureCell(screen : String , categories : [[String : Any]]) {
        viewButton.layer.cornerRadius = 10
        viewButton.layer.masksToBounds = true
        self.screen = screen
        
        if screen == "cat" {
            self.categories = categories
        }else{
            self.subCategories = categories
        }
        collectionView.reloadData()
    }
    
}

//CategoryCollectionCell
extension CategoryCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth/3.4, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "CategoryInnerCell", for: indexPath) as? CategoryInnerCell
        cell?.lblDesc.isHidden = true
        cell?.rateImg.isHidden = true
        cell?.lblName.font = UIFont.systemFont(ofSize: 15)
        
        cell?.rateView.isHidden = true
        cell?.contentView.layer.borderWidth = 0.5
        cell?.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        if screen == "cat" {
            let catDict = self.categories[indexPath.row]
            let urlString  =  catDict["image"] as? String
            cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            
            let name = catDict["name"] as? String
            cell?.lblName.text = name?.capitalized
            
        }else{
            let catDict = self.subCategories[indexPath.row]
            let urlString  =  catDict["categoryimage"] as? String
            cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            
            let name = catDict["categoryname"] as? String
            
            cell?.lblName.text = "From \(name ?? "")"
            
        }
        //categoryname
        
        
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let catDict = self.categories[indexPath.row]
        let cat_id = catDict["id"] as? Int ?? 0
        
        NotificationCenter.default.post(name: Notification.Name("NotificationHomeIdentifier"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
        
        
        //        cellPressAction(eventID: self.nearPlaceModel[indexPath.row].id ?? 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}


//MARK:- Categories

class SubCategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    
    var subCategories =  [[String : Any]]()
    
    var screen = ""
    
    func configureCellForSubCategory(screen : String , categories : [[String : Any]]) {
        viewButton.layer.cornerRadius = 10
        viewButton.layer.masksToBounds = true
        self.screen = screen
        self.subCategories = categories
        collectionView.reloadData()
    }
    
}

//CategoryCollectionCell
extension SubCategoryCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.subCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Constants.windowWidth/2.3, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "CategoryInnerCell", for: indexPath) as? CategoryInnerCell
        cell?.lblDesc.isHidden = true
        cell?.rateImg.isHidden = true
        cell?.lblName.font = UIFont.systemFont(ofSize: 15)
        
        cell?.rateView.isHidden = true
        cell?.contentView.layer.borderWidth = 0.5
        cell?.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        let catDict = self.subCategories[indexPath.row]
        let urlString  =  catDict["categoryimage"] as? String
        cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        
        let name = catDict["categoryname"] as? String
        
        cell?.lblName.text = "From \(name ?? "")"
        
        
        
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let catDict = self.subCategories[indexPath.row]
        let cat_id = catDict["id"] as? Int ?? 0
        
        NotificationCenter.default.post(name: Notification.Name("NotificationHomeIdentifier"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
        
        
        //        cellPressAction(eventID: self.nearPlaceModel[indexPath.row].id ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}



class CategoryInnerCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var rateImg: UIImageView!
    
}

//MARK:- Category END


//fresh Recomendations

//MARK:- Categories

class RecomCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    
    var freshProductsModel =  [HomeRecomModel]()
    
    func configureCell(freshProducts : [[String : Any]]) {
        viewButton.layer.cornerRadius = 10
        viewButton.layer.masksToBounds = true
        freshProductsModel.removeAll()
        for item in freshProducts {
            let model = HomeRecomModel(dict: item)
            self.freshProductsModel.append(model)
        }
        collectionView.reloadData()
    }
    
    
    @objc func plusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview as? RecomInnerCell
        let model =  self.freshProductsModel[sender.tag]
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
            cell?.addItembtn.isHidden = true
            cell?.minusbtn.isHidden = true
            cell?.countLbl.isHidden = true
            cell?.addbtn.isHidden = false
            //            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.addItembtn.isHidden = false
            cell?.minusbtn.isHidden = false
            cell?.countLbl.isHidden = false
            cell?.addbtn.isHidden = true
            //            cell?.addFirstTopConstraint.constant = 100
        }
        
        self.addProductToCart(model: model, tag: sender.tag)
        
        
    }
    
    
    @objc func addFirstBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview as? RecomInnerCell
        let model =  self.freshProductsModel[sender.tag]
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
            cell?.addItembtn.isHidden = true
            cell?.minusbtn.isHidden = true
            cell?.countLbl.isHidden = true
            cell?.addbtn.isHidden = false
            //            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.addItembtn.isHidden = false
            cell?.minusbtn.isHidden = false
            cell?.countLbl.isHidden = false
            cell?.addbtn.isHidden = true
            //            cell?.addFirstTopConstraint.constant = 100
        }
        
        
        //
        
        
        self.addProductToCart(model: model, tag: sender.tag)
    }
    
    @objc func minusBtnAction(sender : UIButton) {
        
        let cell = sender.superview?.superview?.superview as? RecomInnerCell
        let model =  self.freshProductsModel[sender.tag]
        var count = 0
        
        let sizeNum = model.sizeItemNumber ?? 0
        let lblcount = model.sizeprice[sizeNum].quantity
        count = lblcount ?? 0
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
            model.sizeprice[sizeNum].quantity = count
            self.addProductToCart(model: model, tag: sender.tag)
        }
        
        if count == 0 {
            cell?.addItembtn.isHidden = true
            cell?.minusbtn.isHidden = true
            cell?.countLbl.isHidden = true
            cell?.addbtn.isHidden = false
            //            cell?.addFirstTopConstraint.constant = 22.5
        }else{
            
            cell?.addItembtn.isHidden = false
            cell?.minusbtn.isHidden = false
            cell?.countLbl.isHidden = false
            cell?.addbtn.isHidden = true
            //            cell?.addFirstTopConstraint.constant = 100
        }
        
    }
    
    
    
    //MARK:-
    func addProductToCart(model : HomeRecomModel ,tag : Int) {
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
                        let indexPath = IndexPath(item: tag, section: 0)
                        self.collectionView.reloadItems(at: [indexPath])
                        
                    }
                }
                else{
                    
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
                        let indexPath = IndexPath(item: tag, section: 0)
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                    
                }
            }
        }
        
    }
    
    
}

//CategoryCollectionCell
extension RecomCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.freshProductsModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.windowWidth/2.3, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionCell: UICollectionViewCell?
        
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "RecomInnerCell", for: indexPath) as? RecomInnerCell
        cell?.lblName.font = UIFont.systemFont(ofSize: 15)
        cell?.bgView.layer.borderWidth = 1
        cell?.bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        cell?.addItembtn.tag = indexPath.row
        cell?.addbtn.tag = indexPath.row
        cell?.minusbtn.tag = indexPath.row
        
        cell?.addItembtn.isHidden = true
        cell?.minusbtn.isHidden = true
        cell?.countLbl.isHidden = true
        
        cell?.addItembtn.addTarget(self, action: #selector(plusBtnAction(sender:)), for: .touchUpInside)
        cell?.addbtn.addTarget(self, action: #selector(addFirstBtnAction(sender:)), for: .touchUpInside)
        cell?.minusbtn.addTarget(self, action: #selector(minusBtnAction(sender:)), for: .touchUpInside)
        
        
        
        let model = self.freshProductsModel[indexPath.row]
        let sizeprice = model.sizeprice
        
        if sizeprice.count > 0 {
            
            let urlString  =  sizeprice[0].image
            cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        }
        
        let ratings = 0.0
        //prodDict["ratings"] as? Double
        let name = model.name
        cell?.mrpLbl.text = ""
        cell?.pieceAvailableLbl.text = ""
        cell?.discountLbl.text = ""
        cell?.offerLbl.isHidden = true
        
        if sizeprice.count > 0 {
            cell?.offerLbl.isHidden = false
            let mod = sizeprice[0]
            let cutPrice = mod.cut_price
            let price = mod.price
            let size = mod.size
            let discount = mod.discount
            cell?.mrpLbl.text = "MRP : Rs\(cutPrice ?? "0.0")"
            cell?.pieceAvailableLbl.text = "\(size ?? "") Rs\(price ?? "0.0")"
            cell?.offerLbl.text = "\(discount ?? 0)%"
            
            if model.itemSelected ?? 0 > 0 {
                cell?.countLbl.text = "\(model.itemSelected ?? 0)"
                
            }else{
                cell?.countLbl.text = "\(mod.quantity ?? 0)"
                
            }
            
            
            if mod.quantity ?? 0 > 0 {
                //                    cell?.addFirstTopConstraint.constant = 100
                cell?.addbtn.isHidden = true
                cell?.addItembtn.isHidden = false
                cell?.minusbtn.isHidden = false
                cell?.countLbl.isHidden = false
            }
            else{
                //                    cell?.addFirstTopConstraint.constant = 22.5
                cell?.addbtn.isHidden = false
                cell?.addItembtn.isHidden = true
                cell?.minusbtn.isHidden = true
                cell?.countLbl.isHidden = true
            }
        }
        
        cell?.lblName.text = name?.capitalized
        cell?.discountLbl.text = "Rating : \(ratings)"
        
        
        cell?.offerLbl.layer.cornerRadius = 20
        cell?.offerLbl.layer.masksToBounds = true
        
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mod = self.freshProductsModel[indexPath.row]
        let cat_id = mod.product_id as? Int ?? 0
        NotificationCenter.default.post(name: Notification.Name("NotificationDetailIdentifier"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}


class RecomInnerCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mrpLbl: UILabel!
    @IBOutlet weak var pieceAvailableLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var addItembtn: UIButton!
    @IBOutlet weak var minusbtn: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    
}


class SearchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    
    
}

