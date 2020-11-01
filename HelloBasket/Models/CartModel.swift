//
//  CartModel.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 01/11/20.
//

import UIKit

class CartModel {

    let price_total : Int?
    let total : Int?
    let quantity : Int?
    var cartitem = [CartItem]()
    var savelater = [SaveLaterModel]()

    
    init(dict : [String : Any]) {
        
        self.price_total = dict["price_total"] as? Int ?? 0
        self.total = dict["total"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0

        if let cart = dict["cartitem"] as? [[String : Any]] {
            cartitem.removeAll()
            for item  in cart {
                let item1 = CartItem(dict: item)
                cartitem.append(item1)
            }
        }
        
        if let sub_dict = dict["savelater"] as? [[String : Any]] {
            savelater.removeAll()
            for item  in sub_dict {
                let size = SaveLaterModel(dict: item)
                savelater.append(size)
            }
        }
        
        
    }
    
}

class SaveLaterModel {
  
    let savelaterId : Int?
    let name: String?
    let company: String?
    let image : String?
    let product_id : Int?
    let size_id : Int?
    let quantity : Int?
    let min_qty : Int?
    let max_qty : Int?
    let discount : Int?
    let size: String?
    let price: String?
    let cut_price: String?
    let stock : Int?
    let ratings : String?

    init(dict : [String : Any]) {
        
        self.savelaterId = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.company = dict["company"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.product_id = dict["product_id"] as? Int ?? 0
        self.size_id = dict["size_id"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
        self.min_qty = dict["min_qty"] as? Int ?? 0
        self.max_qty = dict["max_qty"] as? Int ?? 0
        self.discount = dict["discount"] as? Int ?? 0
        self.size = dict["size"] as? String ?? ""
        self.price = dict["price"] as? String ?? ""
        self.cut_price = dict["cut_price"] as? String ?? ""
        self.stock = dict["stock"] as? Int ?? 0
        self.ratings = dict["ratings"] as? String ?? ""

    }
    
}


class CartItem {
    
    let cartId : Int?
    let name: String?
    let company: String?
    let image : String?
    let product_id : Int?
    let size_id : Int?
    let quantity : Int?
    let min_qty : Int?
    let max_qty : Int?
    let discount : Int?
    let size: String?
    let price: String?
    let cut_price: String?
    let stock : Int?
    
    var itemSelected : Int?

    
    init(dict : [String : Any]) {
        self.cartId = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.company = dict["company"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.product_id = dict["product_id"] as? Int ?? 0
        self.size_id = dict["size_id"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
        self.min_qty = dict["min_qty"] as? Int ?? 0
        self.max_qty = dict["max_qty"] as? Int ?? 0
        self.discount = dict["discount"] as? Int ?? 0
        self.size = dict["size"] as? String ?? ""
        self.price = dict["price"] as? String ?? ""
        self.cut_price = dict["cut_price"] as? String ?? ""
        self.stock = dict["stock"] as? Int ?? 0
    }
    
}

