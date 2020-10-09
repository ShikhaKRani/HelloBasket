//
//  Loader.swift
//  PartyMantra
//
//  Created by Subhash Kumar on 19/03/20.
//  Copyright © 2020 Shikha. All rights reserved.
//

import SVProgressHUD
import Foundation

class Loader {

    
    
    static func showHud() {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.show()
    }
    
    static func showHudWithNoInteraction(show: Bool) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.show()
    }
    
    static func showHudWithNoInteractionShadow(show: Bool) {
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(UIColor.lightGray)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.show()
    }
    
    static func dismissHud() {
        SVProgressHUD.dismiss()
    }
}
