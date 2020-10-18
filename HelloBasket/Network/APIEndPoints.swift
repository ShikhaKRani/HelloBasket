//
//  Server.swift
//  PartyMantra
//
//  Created by Subhash Kumar on 19/03/20.
//  Copyright © 2020 Shikha. All rights reserved.
//

import Foundation
import UIKit
//
enum ServerEnvironment {
    
    case live, staging, QA
    // Main Server
    var baseURL: String {
        switch self {
        case .QA:
            return "http://hallobasket.appoffice.xyz"
        case .staging:
            return "http://hallobasket.appoffice.xyz"
        case .live:
            return "http://hallobasket.appoffice.xyz"
        }
    }
    //http://hallobasket.appoffice.xyz/api/category
}

// API 2 // get date and get setting//
let currentEnvironment: ServerEnvironment = .staging  //Checkpoint
/// Server base URL string.
public let kBaseURL = currentEnvironment.baseURL
let mainUrl = "\(kBaseURL)/api/"


class APIEndPoints: NSObject, Codable { // checkpoint

    static let shared = APIEndPoints()
    fileprivate var timeInterval = Date().timeIntervalSince1970
    var serverTimeInterval: TimeInterval = Date().timeIntervalSince1970
    

//MARK:- End points
    
    var GET_CATEGORY = "\(mainUrl)category"
    var GET_HOMEDATA = "\(mainUrl)home"
    var GET_WALLETRECHARGE = "\(mainUrl)recharge"
    var GET_VERIFYRECHARGE = "\(mainUrl)verify-recharge"
    var LOGIN = "\(mainUrl)login"
    var PRODUCT_LIST = "\(mainUrl)products"
    var SUBCATEGORY_LIST = "\(mainUrl)sub-category"
    
    override init() {}
    
    required init(from _: Decoder) throws {}

}
