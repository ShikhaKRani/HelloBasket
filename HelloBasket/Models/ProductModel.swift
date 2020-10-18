//
//  ProductModel.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 17/10/20.
//

import UIKit

class ProductModel {
    
    let product_id : Int?
    let name: String?
    let company: String?
    let pro_description : String?
    let ratings : String?
    let image : String?
    let isactive : Int?
    let is_offer : Int?
    let is_hotdeal : Int?
    let is_newarrival : Int?
    let is_discounted : Int?
    let min_qty : Int?
    let max_qty : Int?
    let stock_type : String?
    let stock : Int?
    
    var sizeprice = [SizePrice]()
    
    var itemSelected : Int?
    
    init(dict : [String : Any]) {
        
        self.product_id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.company = dict["company"] as? String ?? ""
        self.pro_description = dict["description"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.ratings = dict["ratings"] as? String ?? ""
        self.isactive = dict["isactive"] as? Int ?? 0
        self.is_offer = dict["is_offer"] as? Int ?? 0
        self.is_hotdeal = dict["is_hotdeal"] as? Int ?? 0
        self.is_newarrival = dict["is_newarrival"] as? Int ?? 0
        self.is_discounted = dict["is_discounted"] as? Int ?? 0
        self.min_qty = dict["min_qty"] as? Int ?? 0
        self.max_qty = dict["max_qty"] as? Int ?? 0
        self.stock_type = dict["stock_type"] as? String ?? ""
        self.stock = dict["stock"] as? Int ?? 0
        
        
        if let sub_dict = dict["sizeprice"] as? [[String : Any]] {
            sizeprice.removeAll()
            for item  in sub_dict {
                let size = SizePrice(dict: item)
                sizeprice.append(size)
            }
        }
    }
    
}

class SizePrice {
    
    let productSize_id : Int?
    let product_id: Int?
    let size: String?
    let image: String?
    let price : Int?
    let cut_price : Int?
    let stock : Int?
    let min_qty : Int?
    let max_qty : Int?
    let consumed_units : Int?
    let in_stocks : Int?
    let quantity : Int?
    let discount : Int?
    
    
    
    init(dict : [String : Any]) {
        
        self.productSize_id = dict["id"] as? Int ?? 0
        self.product_id = dict["product_id"] as? Int ?? 0
        self.size = dict["size"] as? String ?? ""
        self.price = dict["price"] as? Int ?? 0
        self.cut_price = dict["cut_price"] as? Int ?? 0
        self.image = dict["image"] as? String ?? ""
        self.stock = dict["stock"] as? Int ?? 0
        self.min_qty = dict["min_qty"] as? Int ?? 0
        self.max_qty = dict["max_qty"] as? Int ?? 0
        self.consumed_units = dict["consumed_units"] as? Int ?? 0
        self.quantity = dict["quantity"] as? Int ?? 0
        self.in_stocks = dict["in_stocks"] as? Int ?? 0
        self.discount = dict["discount"] as? Int ?? 0
        
    }
}

//MARK:- FILTER PRODUCT


class ProdcutListCategory {
    
    let filters : FiltersProduct?
    var pack_size = [Product_Pack_Size]()
    var categoryData = [CategoryData]()

    
    init(dict : [String : Any]) {
        
        let filter = dict["filters"] as? [String : Any]
        filters = FiltersProduct(dict: filter ?? [:])
                
        if let pack = dict["pack_size"] as? [[String : Any]] {
            pack_size.removeAll()
            for item  in pack {
                let model = Product_Pack_Size(dict: item)
                pack_size.append(model)
            }
        }
        
        if let data = dict["data"] as? [[String : Any]] {
            categoryData.removeAll()
            for item  in data {
                let model = CategoryData(dict: item)
                categoryData.append(model)
            }
        }
    }
}


class CategoryData {
    
    let category_id : Int?
    let cat_id: Int?
    let isactive : Int?
    let name : String?
    var isSelected : Bool?
    
    init(dict : [String : Any]) {
        self.cat_id = dict["id"] as? Int ?? 0
        self.category_id = dict["category_id"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
    }
}



class Product_Pack_Size {
    let size : String?
    let discount: Int?
    init(dict : [String : Any]) {
        self.size = dict["size"] as? String ?? ""
        self.discount = dict["discount"] as? Int ?? 0
    }
}




class FiltersProduct {
    let min_price : Int?
    let max_price : Int?
    
    var sizes = [Filter_Size]()
    var brand = [Filter_Brand]()
    var prices = [Filter_Prices]()
    
    init(dict : [String : Any]) {
        self.min_price = dict["min_price"] as? Int ?? 0
        self.max_price = dict["max_price"] as? Int ?? 0
        
        if let sizesData = dict["sizes"] as? [[String : Any]] {
            sizes.removeAll()
            for item  in sizesData {
                let sizeMOdel = Filter_Size(dict: item)
                sizes.append(sizeMOdel)
            }
        }
        
        if let brandData = dict["brand"] as? [[String : Any]] {
            brand.removeAll()
            for item  in brandData {
                let brandMOdel = Filter_Brand(dict: item)
                brand.append(brandMOdel)
            }
        }
        
        if let pricesData = dict["prices"] as? [[String : Any]] {
            prices.removeAll()
            for item  in pricesData {
                let priceMOdel = Filter_Prices(dict: item)
                prices.append(priceMOdel)
            }
        }
        
    }
}

class Filter_Size {
    let name : String?
    init(dict : [String : Any]) {
        self.name = dict["name"] as? String ?? ""
    }
}

class Filter_Brand {
    let name : String?
    init(dict : [String : Any]) {
        self.name = dict["name"] as? String ?? ""
    }
}

class Filter_Prices {
    let name : String?
    init(dict : [String : Any]) {
        self.name = dict["name"] as? String ?? ""
    }
}
