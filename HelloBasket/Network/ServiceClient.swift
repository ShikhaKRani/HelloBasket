//
//  ServiceClient.swift
//  HelloBasket
//
//  Created by SUBHASH KUMAR on 09/10/20.
//

import UIKit

class ServiceClient {
    
    
    
    class func getHomeListing(parameters: [String: Any]?, handler: (APICompletion<HomeModel>)? = nil) {
        getRequest(url: APIEndPoints.shared.GET_HOMEDATA
            , parameters: parameters, handler: handler)
    }
    
    class func getProductCategory(parameters: [String: Any]?, handler: (APICompletion<[CategoryModel]>)? = nil) {
        getRequest(url: APIEndPoints.shared.GET_CATEGORY
                   , parameters: parameters, handler: handler)
        
    }
        
    
    
    
    
    
    
    
    //    class func LoginUser(parameters: [String: Any]?, handler: (APICompletion<CODE>)? = nil) {
    //        postRequest(url: Server.shared.LoginUrl, parameters: parameters, handler: handler)
    //    }
    //
    //    class func verifyOTP(parameters: [String: Any]?, handler: (APICompletion<VerifyModel>)? = nil) {
    //        postRequest(url: Server.shared.VerifyUrl, parameters: parameters, handler: handler)
    //    }
    //
    //    class func updateProfile(parameters: [String: Any]?, handler: (APICompletion<AddressModel>)? = nil) {
    //        postRequest(url: Server.shared.UpdateProfile, parameters: parameters, handler: handler)
    //
    //
    //    }
    //
    //    class func getHomeListing(parameters: [String: Any]?, handler: (APICompletion<HomeModel>)? = nil) {
    //        getRequest(url: Server.shared.HomeUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //
    //    class func getProfile(parameters: [String: Any]?, handler: (APICompletion<ProfileModel>)? = nil) {
    //        getRequest(url: Server.shared.ProfileUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //    class func getCollectionListing(parameters: [String: Any]?, handler: (APICompletion<CollectionListModel>)? = nil) {
    //        getRequest(url: Server.shared.collectionUrl, parameters: parameters, handler: handler)
    //    }
    //
    //    class func getCollectionEventListing(url: String, parameters: [String: Any]?, handler: (APICompletion<EventListModel>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //    class func getOrderDetails(url: String, parameters: [String: Any]?, handler: (APICompletion<OrderCheckoutModel>)? = nil) {
    //           getRequest(url: url, parameters: parameters, handler: handler)
    //       }
    //
    //
    //    class func getCollectionClubDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<CollectionClubListModel>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //    class func getEventDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<EventDetailsModal>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //    class func getRestrauntDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<Restaurant>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //
    //
    //    class func getPartyDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<PartyDetailsModal>)? = nil) {
    //           getRequest(url: url, parameters: parameters, handler: handler)
    //       }
    //    class func getCollectionDiningDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<CollectionDiningListModel>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //    class func getCollectionPartiesDetailListing(url: String, parameters: [String: Any]?, handler: (APICompletion<CollectionPartiesListModel>)? = nil) {
    //        getRequest(url: url, parameters: parameters, handler: handler)
    //    }
    //
    //
    //
    //    class func getOrderList(parameters: [String: Any]?, handler: (APICompletion<OrderlistModel>)? = nil) {
    //        getRequest(url: Server.shared.getOrderUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //
    //
    //
    //
    //
    //    class func getWalletBalace(parameters: [String: Any]?, handler: (APICompletion<WalletBalance>)? = nil) {
    //        getRequest(url: Server.shared.getWalletBalanceUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //
    //    class func getWalletHistory(parameters: [String: Any]?, handler: (APICompletion<WalletHistoryModel>)? = nil) {
    //        getRequest(url: Server.shared.getWalletHistoryUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //
    //    class func getAddMoney(parameters: [String: Any]?, handler: (APICompletion<AddMoneyModel>)? = nil) {
    //        getRequest(url: Server.shared.addMoneyUrl
    //            , parameters: parameters, handler: handler)
    //    }
    //
    //    class func getNotification(parameters: [String: Any]?, handler: (APICompletion<[notificationModel]>)? = nil) {
    //        getRequest(url: Server.shared.NotificationUrl, parameters: parameters, handler: handler)
    //    }
    //
    
    
    
    
}

//MARK:- POST GET Calls
extension ServiceClient {
    
    class func postRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        // print(url as Any)
        request(url: url, method: .post ,parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func getRequest<T: Decodable>(url: String?, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        // print(url as Any)
        var output: String = ""
        if let param = parameters {
            for (key,value) in param {
                output +=  "\(key)=\(value)&"
            }
        }
        output = String(output.dropLast())
        
        var urlString = url
        if output.count>0 {
            urlString = urlString! + "?\(output)"
        }
        request(url: urlString, method: .get, parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func multipartRequest<T: Decodable>(url: String?,image: UIImage, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        // print(url as Any)
        multiPartRequestCreation(url: url,image: image, contentType: .multipart, method: .post, parameters: parameters, responseKey: responseKey, handler: handler)
    }
    
    class func request<T: Decodable>(url: String?, contentType: RequestContentType = .json, method: RequestMethod, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        guard let url = url else {
            handler?(DataResult.failure(APIError.invalidRequest))
            return
        }
        let responseKeyvalue = "data"
        var params = parameters
        var urlString = url
        if parameters != nil, method == .get {
            params?["_format"] = "json"
        } else {
            urlString = urlString.contains("?") ? (urlString + "&_format=json") : (urlString + "?_format=json")
        }
        
        let resource = APIResource(URLString: urlString, method: method, parameters: params, contentType: contentType, responseKey: responseKeyvalue)
        return Network(resource: resource).sendRequest(completion: handler)
    }
    
    
    class func multiPartRequestCreation<T: Decodable>(url: String?,image: UIImage? , contentType: RequestContentType = .json, method: RequestMethod, parameters: [String: Any]? = nil, responseKey: String? = nil, handler: (APICompletion<T>)? = nil) {
        guard let url = url else {
            handler?(DataResult.failure(APIError.invalidRequest))
            return
        }
        let responseKeyvalue = "data"
        var params = parameters
        var urlString = url
        if parameters != nil, method == .get {
            params?["_format"] = "json"
        } else {
            urlString = urlString.contains("?") ? (urlString + "&_format=json") : (urlString + "?_format=json")
        }
        
        let resource = APIResource(URLString: urlString, method: method, parameters: params, contentType: contentType, responseKey: responseKeyvalue)
        return Network(resource: resource).sendRequest(completion: handler)
    }
    
    
}
