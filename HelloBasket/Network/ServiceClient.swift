//
//  ServiceClient.swift
//  KmsVets
//
//  Created by SUBHASH KUMAR on 19/09/20.
//  Copyright © 2020 Shikha. All rights reserved.
//

import Foundation

class ServiceClient {
    
    class func sendRequest( apiUrl : String,postdatadictionary: [AnyHashable: Any], method :  String ,isArray : Bool, completion: @escaping (Any) -> () ) {
        
        
        let strURL = apiUrl
        let url = URL(string: strURL)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = method
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let accessUserToken =  UserDefaults.standard.string(forKey: "AccessToken")
        urlRequest.setValue("Bearer \(accessUserToken ?? "")", forHTTPHeaderField: "Authorization")
        
        
        
        let body = NSMutableData();
        let boundary = "---------------------------14737809831466499882746641449"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        for (key, value) in postdatadictionary {
            
            if(value is Data)
            {
                let  TimeStamp = "\(Date().timeIntervalSince1970 * 1000)"
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(TimeStamp)\"\r\n".data(using:.utf8)!)
                body.append("field_mobileinfo_image\r\n".data(using: .utf8)!)
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files[field_mobileinfo_image]\"; filename=\"img.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(value as! Data)
                
            }
            else
            {
                if let anEncoding = "--\(boundary)\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let aKey = postdatadictionary[key], let anEncoding = "\(aKey)".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
            }
        }
        
        if let anEncoding = "--\(boundary)--\r\n".data(using: .utf8) {
            body.append(anEncoding)
        }
        // setting the body of the post to the reqeust
        if method == "POST" {
            urlRequest.httpBody = body as Data
        }
        
        URLSession.shared.dataTask(with:urlRequest) { (data, response, error) in
            if error != nil {
                
                print(error!)
                completion("")
            } else {
                do {
                    if isArray {
                        var reponseArray: NSArray?
                        
                        reponseArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray
                        if let newResArray = reponseArray
                        {
                            completion(newResArray)
                        }
                    }
                    else{
                        var dictonary:NSDictionary?
                        dictonary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        if let myDictionary = dictonary
                        {
                            completion(myDictionary)
                        }
                    }
                    
                } catch let error as NSError {
                    completion(error)
                }
            }
                        
        }.resume()
        
    }
    
    
    class func sendPOSTRequest( apiUrl : String,postdatadictionary: [AnyHashable: Any], isArray : Bool, completion: @escaping (Any) -> () ) {
        
        
        let strURL = apiUrl
        let url = URL(string: strURL)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "POST"
        
        let body = NSMutableData();
        let boundary = "---------------------------14737809831466499882746641449"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        urlRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        for (key, value) in postdatadictionary {
            
            if(value is Data)
            {
                let  TimeStamp = "\(Date().timeIntervalSince1970 * 1000)"
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(TimeStamp)\"\r\n".data(using:.utf8)!)
                body.append("field_mobileinfo_image\r\n".data(using: .utf8)!)
                
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"files[field_mobileinfo_image]\"; filename=\"img.jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                body.append(value as! Data)
                
            }
            else
            {
                if let anEncoding = "--\(boundary)\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let aKey = postdatadictionary[key], let anEncoding = "\(aKey)".data(using: .utf8) {
                    body.append(anEncoding)
                }
                if let anEncoding = "\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
            }
        }
        
        if let anEncoding = "--\(boundary)--\r\n".data(using: .utf8) {
            body.append(anEncoding)
        }
        // setting the body of the post to the reqeust
        urlRequest.httpBody = body as Data
        
        URLSession.shared.dataTask(with:urlRequest) { (data, response, error) in
            if error != nil {
                
                print(error!)
                completion("")
            } else {
                do {
                    if isArray {
                        var reponseArray: NSArray?
                        
                        reponseArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray
                        if let newResArray = reponseArray
                        {
                            completion(newResArray)
                        }
                    }
                    else{
                        var dictonary:NSDictionary?
                        dictonary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                        if let myDictionary = dictonary
                        {
                            completion(myDictionary)
                        }
                    }
                    
                } catch let error as NSError {
                    completion(error)
                }
            }
                        
        }.resume()
        
    }
    
    
}
