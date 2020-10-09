//
//  UserDetails.swift
//  PartyMantra
//
//  Created by Vibhash Kumar on 30/03/20.
//  Copyright © 2020 Shikha. All rights reserved.
//

import UIKit

class UserDetails: NSObject {
  static let shared = UserDetails()
    let bearerToken = "AccessToken"

    
    private override init() { }
    
    //MARK: SET Details
    func setAccessToken( token :  String) {
        UserDefaults.standard.set(token, forKey: bearerToken)
    }
    
    //MARK: Get Details
    func getAccessToken() -> String {
        if let bearerToken = UserDefaults.standard.value(forKey: bearerToken) as? String {
            return bearerToken
        }
        return ""
    }
    
    //MARK: Remove Details
    func removeAccessToken() -> Void {
        UserDefaults.standard.removeObject(forKey: bearerToken)
        
    }
    
    
    

    
   
}
