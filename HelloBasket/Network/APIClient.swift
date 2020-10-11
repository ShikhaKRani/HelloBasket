//
//  APIClient.swift
//  KmsVets
//
//  Created by SUBHASH KUMAR on 13/09/20.
//  Copyright © 2020 Shikha. All rights reserved.
//

import Foundation

struct BaseUrl {
    static let BASE = "http://wisdompetclinic.xyz"

}

struct AppURL {
    static let SLIDER_URL = "\(BaseUrl.BASE)/userfiles/contents/big/"
    
    
    static let ICON_URL = "\(BaseUrl.BASE)/userfiles/products/big/"
}


struct APIUrl {
    
    static let LOGIN_URL  = "\(BaseUrl.BASE)?component=json&action=get_search_password"
    static let GET_CONTACT  = "\(BaseUrl.BASE)?component=json&action=get_contact"
    static let ORDER_DETAILS  = "\(BaseUrl.BASE)?component=json&action=order_detail"
    static let GET_SLIDER_IMAGE  = "\(BaseUrl.BASE)?component=json&action=get_slider_image"
    static let GET_PET_LIST  = "\(BaseUrl.BASE)/visitapi/index.php/getpet_list"
    static let GET_OTP  = "http://api.msg91.com/api/sendhttp.php"
    static let PROFILE_UPDATE  = "\(BaseUrl.BASE)/visitapi/index.php/updateprofile"
    static let BOOK_NEW_PUPPY  = "\(BaseUrl.BASE)/visitapi/index.php/newpuppy"
    static let GET_NEW_PUPPY  = "\(BaseUrl.BASE)/visitapi/index.php/getnewpuppy"
    static let BOOK_SURGERY  = "\(BaseUrl.BASE)/visitapi/index.php/book_surgry"
    static let BOOK_SURGERY_HISTORY  = "\(BaseUrl.BASE)/visitapi/index.php/getsurgery"
    static let QUESTION_PRICE  = "\(BaseUrl.BASE)/visitapi/index.php/getquestion_price"
    static let SERVICE_LIST  = "\(BaseUrl.BASE)/visitapi/index.php/visit"
    static let ASK_Question  = "\(BaseUrl.BASE)/visitapi/index.php/ask_question"
    static let GET_CATEGORY  = "\(BaseUrl.BASE)?component=json&action=get_categories"
    static let PRODUCT_CATEGORY_LIST  = "\(BaseUrl.BASE)?component=json&action=latest_product"
    static let GET_CART  = "\(BaseUrl.BASE)/index.php?component=json&action=get_cart"
    static let ADD_CART  = "\(BaseUrl.BASE)/index.php?component=json&action=add_cart"
    static let DELET_ALL_CART  = "\(BaseUrl.BASE)/index.php?component=json&action=delete_cart"
    static let BOOK_SERVICE  = "http://wisdompetclinic.xyz/visitapi/index.php/book_service"
    static let BOOK_ORDER    = "http://wisdompetclinic.xyz/index.php?component=json&action=add_order"
    static let PAYMENT_STATUS    = "http://wisdompetclinic.xyz/index.php?component=json&action=check_payment_status"

    static let GET_PRODUCT_DETAILS    = "http://wisdompetclinic.xyz/index.php?component=json&action=get_product_detail"
    static let GET_ORDER    = "http://wisdompetclinic.xyz/index.php?component=json&action=get_order"

    static let CHECK_PET_ID    = "http://wisdompetclinic.xyz/visitapi/index.php/checkpetid"

    static let GET_PINCODE    = "http://wisdompetclinic.xyz/visitapi/index.php/pincode"
    static let GetVisit_Charge    = "http://wisdompetclinic.xyz/visitapi/index.php/getvisit_charge"
    static let PET_BOOK_SERVICE    = "http://wisdompetclinic.xyz/visitapi/index.php/book_service"
    static let GET_SERVICE    = "http://wisdompetclinic.xyz/visitapi/index.php/getservice"
    static let CANCEL_ORDER    = "http://wisdompetclinic.xyz/index.php?component=json&action=cancle_order"
    static let ORDER_DETAIL    = "http://wisdompetclinic.xyz/index.php?component=json&action=order_detail"
    
    static let REPEAT_ORDER   = "http://wisdompetclinic.xyz/index.php?component=json&action=repeat_order"
    
}

