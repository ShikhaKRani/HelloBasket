//
//  CartViewController-Ext.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 01/11/20.
//

import Foundation
import UIKit

extension CartViewController {
    
}

class SavelaterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    
    var cartModel : CartModel?
    
    func configureCell(model : CartModel?) {
        viewButton.layer.cornerRadius = 10
        viewButton.layer.masksToBounds = true
        self.cartModel = model
        collectionView.reloadData()
    }
    
    @objc func addFirstBtnAction(sender : UIButton) {
        
        if let model =  self.cartModel?.savelater[sender.tag] {
            var count = 0
            count = model.quantity ?? 0
            if model.min_qty ?? 0 > 0 {
                count = model.min_qty ?? 0
                model.itemSelected = count
            }
            
            self.addProductToCart(model: model, tag: sender.tag)
        }
    }
    
    //MARK:-
    func addProductToCart(model :SaveLaterModel, tag : Int) {
        //        ADD_CART
        //product_id
        //size_id
        //quantity
        
        var param: [String: Any] = [:]
        param = ["quantity" : "\(model.itemSelected ?? 0)","product_id" : "\(model.product_id ?? 0)","size_id" : model.size_id ?? 0]
        
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.ADD_CART, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                let msg = res["message"] as? String

                if res["status"] as? String == "success" {
                    
                        NotificationCenter.default.post(name: Notification.Name("SaveLater"), object: nil, userInfo: ["status":"1", "msg" : msg ?? ""])

                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: tag, section: 0)
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                }else{
                    let model = model
                    if model.stock ?? 0 > 0 {
                        model.itemSelected = model.quantity
                    }else{
                        model.itemSelected = 0
                    }
                    NotificationCenter.default.post(name: Notification.Name("SaveLater"), object: nil, userInfo: ["status":"0", "msg" : msg ?? ""])

                    
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
extension SavelaterCollectionCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cartModel?.savelater.count ?? 0
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
        
        let saveLaterModel = self.cartModel?.savelater[indexPath.row]
        let urlString  =  saveLaterModel?.image
        cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
        let ratings = saveLaterModel?.ratings
        let name = saveLaterModel?.name
        let cutPrice = saveLaterModel?.cut_price
        let price = saveLaterModel?.price
        let size = saveLaterModel?.size
        let discount = saveLaterModel?.discount
        cell?.mrpLbl.text = "MRP : Rs\(cutPrice ?? "0")"
        cell?.pieceAvailableLbl.text = "\(size ?? "") Rs\(price ?? "0")"
        cell?.offerLbl.text = "\(discount ?? 0)%"
        cell?.lblName.text = name?.capitalized
        cell?.discountLbl.text = "Rating : \(ratings ?? "0.0")"
        cell?.offerLbl.layer.cornerRadius = 20
        cell?.offerLbl.layer.masksToBounds = true
        
        cell?.addbtn.tag = indexPath.row
        cell?.addbtn.addTarget(self, action: #selector(addFirstBtnAction(sender:)), for: .touchUpInside)

    
        collectionCell = cell
        return collectionCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let saveLaterModel = self.cartModel?.savelater[indexPath.row]
        let cat_id = saveLaterModel?.product_id
        
        print("cat_id ======>>> ",cat_id)
//        NotificationCenter.default.post(name: Notification.Name("NotificationDetailIdentifier"), object: nil, userInfo: ["cat_Id":"\(cat_id)"])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}




class CartItemCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var saveLaterBtn: UIButton!
    @IBOutlet weak var removebtn: UIButton!
    
}
