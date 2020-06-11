//
//  API.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration

enum ResponseResult {
    case none, noInternet, serverError(String), success, failed(String)
}

class ResponseError {
    var errorMessage: String?
    init(data: [String : Any]?) {
        
        if let data = data, let error_message = data["error_message"] as? String {
            self.errorMessage = error_message
        } else {
            
            self.errorMessage = "Ошибка на сервере. Попробуйте позднее"
        }
        
        
    }
}

class API {
    
    let domain = "http://radioversta.ru/wp-json/wp/v2"
    
     static let shared = API()
    
     
    
    enum UrlLink {
        case post
        case event
        case media
       
       
           
           
       func getUrlLink() -> String {
         
           switch self {
           case .post:
            return "/posts"
           case .event:
            return "/event"
            case .media:
            return "/media/"
           
           
           }
       }
    }
       
    
       
       //MARK: - Set manager
       
       func getSessionManager(url: URL) -> Session {
           let configuration = URLSessionConfiguration.default
           let sessionManager = Alamofire.Session(configuration: configuration)
           
           return sessionManager
       }
       

    
        //MARK: - Check internet connection
       
       func isInternetAvailable() -> Bool {
           var zeroAddress = sockaddr_in()
           zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
           zeroAddress.sin_family = sa_family_t(AF_INET)
           
           let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
               $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
               }
           }
           
           var flags = SCNetworkReachabilityFlags()
           if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
               return false
           }
           let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
           let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
           return (isReachable && !needsConnection)
       }
    
    //MARK: - CONVERT
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func getPostList(closure: @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json",]
        let url = URL(string: self.domain + UrlLink.post.getUrlLink())
        
        
        print("getPostList URL --> \(String(describing: url))")
    
        AF.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
        
                print("getPostList REQUEST --> \(response)")
                switch (response.result) {
                case .success(let value):
                    if let data = value as? [[String: AnyObject]]
                    {
                        closure(data, .success)
                    } else {
                        
                        closure(nil, .failed(""))
                        
                    }
                    break
                case .failure(let error):
                    print("getPostLits ---> " + error.localizedDescription)
                    
                    if let data = response.data,
                        let json = String(data: data, encoding: String.Encoding.utf8) {
                        
                        print(error)
                        
                        
                        let jsonDict = self.convertToDictionary(text: json)
                        print("Failure Response: \(jsonDict)")
                        let responseError = ResponseError(data: jsonDict)
                        print("response.response?.statusCode \(response.response?.statusCode)")
                       
                        closure(nil, .serverError("\(responseError.errorMessage)"))
                        
                        
                    }
                }
        }
    }
    
    func getEventList(closure: @escaping ([[String : Any]]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json",]
        let url = URL(string: self.domain + UrlLink.event.getUrlLink())
        
        
        print("getPostList URL --> \(String(describing: url))")
    
        AF.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
        
                print("getPostList REQUEST --> \(response)")
                switch (response.result) {
                case .success(let value):
                    if let data = value as? [[String: AnyObject]]
                    {
                        closure(data, .success)
                    } else {
                        
                        closure(nil, .failed(""))
                        
                    }
                    break
                case .failure(let error):
                    print("getPostLits ---> " + error.localizedDescription)
                    
                    if let data = response.data,
                        let json = String(data: data, encoding: String.Encoding.utf8) {
                        
                        print(error)
                        
                        
                        let jsonDict = self.convertToDictionary(text: json)
                        print("Failure Response: \(jsonDict)")
                        let responseError = ResponseError(data: jsonDict)
                        print("response.response?.statusCode \(response.response?.statusCode)")
                       
                        closure(nil, .serverError("\(responseError.errorMessage)"))
                        
                        
                    }
                }
        }
    }
    
    func getMedia(mediaId:Int, closure: @escaping ([String : Any]?, ResponseResult) -> ()) {
        
        guard isInternetAvailable() else {
            closure(nil, .noInternet)
            return
        }
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json",]
        let url = URL(string: self.domain + UrlLink.media.getUrlLink() + "\(mediaId)")
        
        
        print("getPostList URL --> \(String(describing: url))")
    
        AF.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
        
                print("getPostList REQUEST --> \(response)")
                switch (response.result) {
                case .success(let value):
                    if let data = value as? [String: AnyObject]
                    {
                        closure(data, .success)
                    } else {
                        
                        closure(nil, .failed(""))
                        
                    }
                    break
                case .failure(let error):
                    print("getPostLits ---> " + error.localizedDescription)
                    
                    if let data = response.data,
                        let json = String(data: data, encoding: String.Encoding.utf8) {
                        
                        print(error)
                        
                        
                        let jsonDict = self.convertToDictionary(text: json)
                        print("Failure Response: \(jsonDict)")
                        let responseError = ResponseError(data: jsonDict)
                        print("response.response?.statusCode \(response.response?.statusCode)")
                       
                        closure(nil, .serverError("\(responseError.errorMessage)"))
                        
                        
                    }
                }
        }
    }
  
}
