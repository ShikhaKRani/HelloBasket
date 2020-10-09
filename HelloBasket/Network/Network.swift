//
//  Network.swift
//  PartyMantra
//
//  Created by Apple on 23/10/19.
//  Copyright © 2019 abc. All rights reserved.
//

import Foundation
import UIKit

typealias CODE = Int

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        
        return String(data: theJSONData, encoding: .ascii)
    }
}

class Network {
    let apiResource: APIResource!
    let decoder = JSONDecoder()
    
    init(resource: APIResource?) {
        self.apiResource = resource
    }
    
    func sendRequest<T: Decodable>(completion: APICompletion<T>?) //-> DataRequestID
    {
        let url = URL(string: apiResource.urlString)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let accessUserToken =  UserDetails.shared.getAccessToken()
        request.setValue("Bearer \(accessUserToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = self.apiResource.method.rawValue
        var jsonData :Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: apiResource.parameter!, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
            }
        
            if apiResource.contentType == .multipart {
                let body = NSMutableData();
                let boundary = "---------------------------14737809831466499882746641449"
                let contentType = "multipart/form-data; boundary=\(boundary)"
                request.addValue(contentType, forHTTPHeaderField: "Content-Type")
                
                
                if let formdata = apiResource?.formData {
                    let  TimeStamp = "\(Date().timeIntervalSince1970 * 1000)"
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"\(formdata.keyName)\"; filename=\"\(TimeStamp)\"\r\n".data(using:.utf8)!)
                    body.append("field_mobileinfo_image\r\n".data(using: .utf8)!)
                    
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"files[field_mobileinfo_image]\"; filename=\"img.jpg\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    
                    //                var imgData: Data? = nil
                    //                if let aKey = value as? Data {
                    //                    imgData = NSData(data: aKey) as Data
                    //                }
                    
                    body.append(formdata.data!)
                }
                
                
                
                
                
                
                for (key, value) in apiResource.parameter ?? [:] {
                    
                    
                    if let anEncoding = "--\(boundary)\r\n".data(using: .utf8) {
                        body.append(anEncoding)
                    }
                    if let anEncoding = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8) {
                        body.append(anEncoding)
                    }
                    if let anEncoding = "\(value)".data(using: .utf8) {
                        body.append(anEncoding)
                    }
                    if let anEncoding = "\r\n".data(using: .utf8) {
                        body.append(anEncoding)
                    }
                }
                
                if let anEncoding = "--\(boundary)--\r\n".data(using: .utf8) {
                    body.append(anEncoding)
                }
                // setting the body of the post to the reqeust
                request.httpBody = body as Data
                
            } else if apiResource.method == .post{
                request.httpBody = jsonData
            }
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                let result: DataResult<T>
                do {
                    let data1 = data
//                    print(String(data: data!, encoding: .utf8)!)
//                    let string = String(data: data!, encoding: .utf8)!
//                    let needle: Character = "}"
//                    if let idx = string.lastIndex(of: needle) {
//                        let pos = string.distance(from: string.startIndex, to: idx)
//                        print("Found \(needle) at position \(pos)")
//                        let pos1 = pos+1
//                        if pos+1 != string.count {
//                            let index = string.index(string.startIndex, offsetBy: pos1)
//                            let mySubstring = string[..<index] // Hello
//                            print(mySubstring)
//                            data1 = Data(mySubstring.utf8)
//                        }
//                    }
//                    else {
//                        print("Not found")
//                    }
                    let parseResult: APIResponse<T> = try self.parseJSON(data: data1, error: error, responseData: response)
                    result = DataResult.success(parseResult)
                    DispatchQueue.main.async {
                    completion?(result)
                    }
                } catch {
                    print("error")
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func validate(data: Data?, error: Error?, responseData: URLResponse? = nil) -> (success: Bool, error: APIError?) {
        /// Here just basic validation checking data is nil or not and error is present.
        var validationError: APIError?
        if error != nil {
            var errorMessage: String?
            var code = (error as NSError?)?.code
            do {
                if let jsonData = data {
                    if let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
                        errorMessage = jsonResult["message"] as? String
                        if let c = jsonResult["code"] as? Int {
                            code = c
                        }
                         print(jsonResult)
                    }
                }
                let msg = errorMessage ?? (error as NSError?)?.localizedDescription
                if code == 403 {
                    validationError = APIError.accountBlocked(message: msg)
                } else if code == APIStatusCode.invalidAccessToken.rawValue {
                    validationError = APIError.invalidAccessToken
                } else {
                    validationError = APIError.generalError(code: code, message: msg)
                }
                let status = (validationError == nil) ? true : false
                return (status, validationError)
            } catch {}
        }
        if data == nil {
            validationError = APIError.invalidResponse
        }
        let status = (validationError == nil) ? true : false
        return (status, validationError)
    }
    
    func parseJSON<T: Decodable>(data: Data?, error: Error?, responseData: URLResponse? = nil) throws -> APIResponse<T> {
        var parsedModel: APIResponse<T>
        
        let validation = self.validate(data: data, error: error, responseData: responseData)
        guard validation.success, validation.error == nil else {
            throw validation.error!
        }
        
        do {
        var json = try JSONSerialization.jsonObject(with: data!, options: [])
        }
        catch {
            print(error.localizedDescription)
        }
        
        var json = try JSONSerialization.jsonObject(with: data!, options: [])
        
        var statusCode = NSNotFound
        var message = ""
        var typeval = ""
        var timeInterval: TimeInterval = Date().timeIntervalSince1970
        
        if nil != json as? JSONDictionary {
            ///Getting status code from the response.
            if let sCode = (json as AnyObject).value(forKeyPath: "code") as? Int {
                statusCode = sCode
            } else if let codeStr = (json as AnyObject).value(forKeyPath: "code") as? String, let sCode = Int(codeStr) {
                statusCode = sCode
            }
            if let mes = (json as AnyObject).value(forKeyPath: "message") as? String {
                message = mes
            }
            if let time = (json as AnyObject).value(forKeyPath: "time") as? TimeInterval {
                timeInterval = time
                //                Server.shared.serverTimeInterval = time
            }
            if let errorType = (json as AnyObject).value(forKeyPath: "type") as? String {
                typeval = errorType
            }
            ///Getting the data from required key paths
            if let keyPath = self.apiResource?.responseKeyPath, let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                json = nestedJson
            }
        } else {
            statusCode = 200
        }
        guard type(of: json) != NSNull.self else {
            //return (nil, validation.error)
            
            throw APIError.parsingError
        }
        
        //        let headers = responseData.
        
        if T.self == CODE.self {
            ///If API is requested just to return status code. we don't do decoding.
            parsedModel = APIResponse<T>(statusCode: statusCode, data: nil, message: message, timeInterval: timeInterval, type: typeval)
        } else {
            var obj: T?, parseError: APIError?
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                ///Actual model creation happens here.
                obj = try self.decoder.decode(T.self, from: data)
            } catch let error {
                
                print(error)
                ///Some decoding error occured.
                parseError = APIError.parsingError
            }
            
            ///Some API returns just status code in some scenarios.
            ///to handle that we check for parsed object and status code.
            if obj == nil, statusCode != NSNotFound {
                ///If object is nil and contain valid status code. then we need to pass success response in completion.
                parsedModel = APIResponse<T>(statusCode: statusCode, data: nil, message: message, timeInterval: timeInterval, type: typeval)
            } else if let model = obj {
                parsedModel = APIResponse<T>(statusCode: statusCode, data: model, message: message, timeInterval: timeInterval, type: typeval)
            } else {
                //throwing parse error
                throw parseError ?? APIError.parsingError
            }
        }
        return parsedModel
    }
    
}
