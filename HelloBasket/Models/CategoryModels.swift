//
//  CategoryModels.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 14/10/20.
//

import UIKit

class CategoryModels: NSObject {
    
    let cat_id : Int?
    let name: String?
    let image: String?
    let isactive : Int?
    var isTapped : Bool?
    var subCatModelArray = [SubCategoryModels]()
    
    init(dict : [String : Any]) {
        
        self.cat_id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.image = dict["image"] as? String ?? ""
        self.isactive = dict["isactive"] as? Int ?? 0
        
        if let sub_dict = dict["subcategory"] as? [[String : Any]] {
            subCatModelArray.removeAll()
            for item  in sub_dict {
                let subCatModel = SubCategoryModels(dict: item)
                subCatModelArray.append(subCatModel)
            }
        }
    }
}

class SubCategoryModels {
    
    let sub_id : Int?
    let category_id : Int?
    let name: String?
    let isactive : Int?
    
    
    init(dict : [String : Any]) {
        
        self.sub_id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.category_id = dict["category_id"] as? Int ?? 0
        self.isactive = dict["isactive"] as? Int ?? 0

    }
    
    
}

