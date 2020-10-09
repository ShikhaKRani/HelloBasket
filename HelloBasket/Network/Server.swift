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
            return "http://partymantra.appoffice.xyz"
        case .staging:
            return "http://partymantra.appoffice.xyz"
        case .live:
            return "http://partymantra.appoffice.xyz"
        }
    }
    
}

// API 2 // get date and get setting//
let currentEnvironment: ServerEnvironment = .staging  //Checkpoint
/// Server base URL string.
public let kBaseURL = currentEnvironment.baseURL
let mainUrl = "\(kBaseURL)/api/"


class APIEndPoints: NSObject, Codable { // checkpoint

    static let shared = APIEndPoints()
    fileprivate var timeInterval = Date().timeIntervalSince1970
    
    

    var LoginUrl = "\(mainUrl)login"
    var VerifyUrl = "\(mainUrl)verify-otp"
    var UpdateProfile = "\(mainUrl)update-profile"
    var bookOrder = "\(mainUrl)book"
    var UpdateAddress = "\(mainUrl)update-address"

    var HomeUrl = "\(mainUrl)home"
    var ProfileUrl = "\(mainUrl)profile"
    
    // Collection
    var collectionUrl = "\(mainUrl)collections"
    var collectioEventUrl = "\(mainUrl)collection"

    // Events
    var eventsUrl = "\(mainUrl)event"
    var restaurentUrl = "\(mainUrl)restaurant"
    var partyUrl = "\(mainUrl)party"

    var searchUrl = "\(mainUrl)search"

    
    var orderDetailUrl = "\(mainUrl)order-details"
    var collectionDetailUrl = "\(mainUrl)collection"
    var getWalletBalanceUrl = "\(mainUrl)wallet-balance"
    var getWalletHistoryUrl = "\(mainUrl)wallet-history"
    var getOrderUrl = "\(mainUrl)order-history"
    var NotificationUrl = "\(mainUrl)notifications"
    var addMoneyUrl="\(mainUrl)add-money"
    var paynowUrl="\(mainUrl)pay-now"
    var paybillUrl="\(mainUrl)pay-bill"
    
    var verifyCartMoneyUrl="\(mainUrl)verify-payment"
    var verifyMoneyUrl="\(mainUrl)verify-recharge"
    var cancelOrderUrl = "\(mainUrl)cancel-order"
    var reviewOrderUrl = "\(mainUrl)submit-review"
    var reviewListUrl = "\(mainUrl)"
    var verifyBillMoneyUrl="\(mainUrl)verify-bill"

    

    
    
//    var resendOTP = "http://api.msg91.com/api/sendhttp.php"
    
    var serverTimeInterval: TimeInterval = Date().timeIntervalSince1970
    

    
    override init() {}
    
    required init(from _: Decoder) throws {}

}
