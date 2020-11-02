//
//  CartViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 24/10/20.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var placeOrderbtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var productList = [ProductModel]()
    var cartModelStored : CartModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        self.navView.backgroundColor = AppColor.themeColor
        backBtn.addTarget(self, action: #selector(backbtnAction), for: .touchUpInside)
        self.navTitle.text = "Cart"
        self.placeOrderbtn.backgroundColor = AppColor.themeColor
        self.placeOrderbtn.addTarget(self, action: #selector(placeOrderBtnAction(sender:)), for: .touchUpInside)

        
        self.fetchCartDetailList()
        
    }
    //MARK:-
    
    @objc func backbtnAction() { self.navigationController?.popViewController(animated: true)    }
    
    func registerCell() {
        //        tblView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
    }
    //MARK:-
    //MARK:- fetchCartDetailList
    
    func fetchCartDetailList() {
        
        let param: [String: Any] = [:]
        Loader.showHud()
        ServiceClient.sendRequestGET(apiUrl: APIEndPoints.shared.GET_CART_DETAILS, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            self.cartModelStored = nil
            if let res = response as? [String : Any] {
                let model = CartModel(dict: res)
                self.cartModelStored = model
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.totalAmountLbl.text = "Total : \(StringConstant.RupeeSymbol)\(self.cartModelStored?.price_total ?? 0)"
                }
            }
        }
    }
    
    
    @objc func placeOrderBtnAction(sender : UIButton) {
        
        
    }
    
    //MARK:- Remove & Save later
    
    
    @objc func removeBtnAction(sender : UIButton) {
        let model =  self.cartModelStored?.cartitem[sender.tag]
        model?.itemSelected = 0
        self.addProductToCart(model: self.cartModelStored!, tag: sender.tag)
    }

    @objc func saveLaterBtnAction(sender : UIButton) {
        
        let model =  self.cartModelStored?.cartitem[sender.tag]
        let param: [String: Any] =  ["product_id" : "\(model?.product_id ?? 0)","size_id" : model?.size_id ?? 0]
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.SAVE_LATER_CART_PRODUCT, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                if res["status"] as? String == "success" {
                    self.fetchCartDetailList()
                }else{
                    print(res["message"] ?? "")
                }
            }
        }
    }
    
    //MARK:- Add and Minus product
    @objc func plusBtnAction(sender : UIButton) {
        
        let model =  self.cartModelStored?.cartitem[sender.tag]
        var count = 0
        count = model?.quantity ?? 0
        if model?.itemSelected ?? 0 > 0 {
            count = model?.itemSelected ?? 0
        }
        count = count + 1
        model?.itemSelected = count
        self.addProductToCart(model: self.cartModelStored!, tag: sender.tag)
    }
    
    
    @objc func minusBtnAction(sender : UIButton) {
        
        let model =  self.cartModelStored?.cartitem[sender.tag]
        var count = 0
        count = model?.quantity ?? 0
        if model?.itemSelected ?? 0 > 0 {
            count = model?.itemSelected ?? 0
        }
        if count > 0 {
            count = count - 1
        }
        
        model?.itemSelected = count
        
        if count == 0 {
            //remove product
        }
        
        
        if model?.itemSelected ?? 0 < model?.min_qty ?? 0 {
            count = 0
            model?.itemSelected = count
        }
        
        self.addProductToCart(model: self.cartModelStored!, tag: sender.tag)
    }
    
    
    func addProductToCart(model :CartModel, tag : Int) {
        //        ADD_CART
        //product_id
        //size_id
        //quantity
        let mod =  model.cartitem[tag]
        var param: [String: Any] = [:]
        param = ["quantity" : "\(mod.itemSelected ?? 0)","product_id" : "\(mod.product_id ?? 0)","size_id" : mod.size_id ?? 0]
        
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.ADD_CART, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                let msg = res["message"] as? String
                if res["status"] as? String == "success" {
                    
                    if mod.itemSelected ?? 0 < mod.min_qty ?? 0 {
                        self.fetchCartDetailList()
                    }else{
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: tag, section: 0)
                            self.collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }else{
                    let model = mod
                    if model.stock ?? 0 > 0 {
                        model.itemSelected = mod.quantity
                    }else{
                        model.itemSelected = 0
                    }
                    
                    DispatchQueue.main.async {
                        self.view.makeToast("\(msg ?? "")", duration: 3.0, position: .bottom)
                        let indexPath = IndexPath(item: tag, section: 0)
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                    
                }
            }
        }
        
    }
    
    
    
    
}


extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.cartModelStored?.cartitem.count ?? 0
        }
        if section == 1 {
            return 1
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let rowCount = self.cartModelStored?.cartitem.count ?? 0
            if rowCount > 0 {
                return CGSize(width: Constants.windowWidth, height: CGFloat(1 * 185))
            }
            return CGSize(width: Constants.windowWidth, height: CGFloat(0))
        }
        
        else if indexPath.section == 1 {
            let rowCount = self.cartModelStored?.savelater.count
            if rowCount ?? 0 > 0 {
                return CGSize(width: Constants.windowWidth, height: 360)
            }
            return CGSize(width: Constants.windowWidth, height: 0)
        }
        
        
        return CGSize(width: Constants.windowWidth, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.0, height: 0.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var collectionCell: UICollectionViewCell?
        
        if indexPath.section == 0 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(CartItemCollectionCell.self)", for: indexPath) as? CartItemCollectionCell
            let model = self.cartModelStored?.cartitem[indexPath.row]
            cell?.lblDiscount.backgroundColor = AppColor.themeColorSecond
            cell?.lblDiscount.textColor = .white
            cell?.lblName.text = "\(model?.name ?? "") (\(model?.company ?? ""))"
            cell?.lblMrp.text = "MRP \(model?.cut_price ?? "")"
            cell?.lblDiscount.text = "\(model?.discount ?? 0) % OFF"
            cell?.lblSize.text = "\(model?.size ?? "1") for  \(StringConstant.RupeeSymbol)\(model?.price ?? "0")"
            
            let urlString  =  model?.image
            cell?.imgView.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: UIImage(named: "medicine.jpeg") ,options: .refreshCached, completed: nil)
            
            
            if model?.itemSelected ?? 0 > 0 {
                cell?.countLbl.text = "\(model?.itemSelected ?? 0)"
            }else{
                cell?.countLbl.text = "\(model?.quantity ?? 0)"
            }
                 
            cell?.btnPlus.tag = indexPath.row
            cell?.btnMinus.tag = indexPath.row
            cell?.saveLaterBtn.tag = indexPath.row
            cell?.removebtn.tag = indexPath.row
            
            cell?.btnPlus.addTarget(self, action: #selector(plusBtnAction(sender:)), for: .touchUpInside)
            cell?.btnMinus.addTarget(self, action: #selector(minusBtnAction(sender:)), for: .touchUpInside)
            
            cell?.saveLaterBtn.addTarget(self, action: #selector(saveLaterBtnAction(sender:)), for: .touchUpInside)
            cell?.removebtn.addTarget(self, action: #selector(removeBtnAction(sender:)), for: .touchUpInside)
            
            
            
            collectionCell = cell
        }
        
        
        if indexPath.section == 1 {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "\(SavelaterCollectionCell.self)", for: indexPath) as? SavelaterCollectionCell
            cell?.headerLbl.text = "Saved For Later"
            cell?.configureCell(model: self.cartModelStored)
            collectionCell = cell
        }
        
        
        return collectionCell ?? UICollectionViewCell()
    }
    
    
}
