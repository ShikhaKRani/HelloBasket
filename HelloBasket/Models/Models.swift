//
//  Models.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 09/10/20.
//

import Foundation

//MARK:- CategoryModel

struct CategoryModel : Codable {
    let id : Int?
    let name: String?
    let image: String?
    let isactive : Int?
    var isTapped : Bool?
    let subcategory : [SubCategoryModel]?
}

struct SubCategoryModel : Codable {
    let id : Int?
    let category_id : Int?
    let name: String?
    let isactive : Int?
}

//MARK:- CategoryModel



