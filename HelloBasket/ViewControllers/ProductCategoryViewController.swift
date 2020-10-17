//
//  ProductCategoryViewController.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 11/10/20.
//

import UIKit

class ProductCategoryViewController: UIViewController {

    var prevDict : [String: Any]?
    var catId : String?
    var screen : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        if screen == "home" {
            if let cat_id = prevDict?["cat_Id"] {
                catId = "\(cat_id )"
                print(cat_id)
                self.fetchCategoryData()
            }
        }
        else{
            
        }
                
    }

    
    
    func fetchCategoryData() {
        //http://hallobasket.appoffice.xyz/api/products?category_id=2
        
        var param: [String: Any] = [:]
        param = ["category_id" : "\(catId ?? "0")"]
        
        Loader.showHud()
        ServiceClient.sendRequestPOSTBearer(apiUrl: APIEndPoints.shared.PRODUCT_LIST, postdatadictionary: param, isArray: false) { (response) in
            Loader.dismissHud()
            if let res = response as? [String : Any] {
                print(res)
            }
        }
    }
    
    
    
}
