//
//  NewsModel.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import Foundation

protocol NewsModelDelegate {
    func showSpinner()
    func hideSpinner()
    func showAlertNoInternet(closure: @escaping (()->()))
    func showAlertWithOK(title: String, msg: String)

}

class NewsModel {
    var delegate: NewsModelDelegate?
    let apiManager = API()
    
    func getPostLists(closure: @escaping (([[String: Any]])->())) {
        self.delegate?.showSpinner()
      
        apiManager.getPostList() { (data, result) in
            switch result {
            case .success:
                self.delegate?.hideSpinner()
                
                if let _data = data {
                    
                    closure(_data)
                }

                
            case .failed(let code), .serverError(let code):
                self.delegate?.hideSpinner()
                
            case .noInternet:
                self.delegate?.hideSpinner()
                self.delegate?.showAlertNoInternet {
                    self.getPostLists(closure: closure)
                }
            default:
                self.delegate?.hideSpinner()
                break
                
            }
        }
    }
}

class PostModel {
    var id: Int?
    var date: String?
    var title: String?
    var content: String?
    var featuredmedia: Int?



    
    init(data: [String: Any]?) {
        self.id = data?["id"] as? Int
        self.date = data?["date"] as? String
        let titleNotRender = data?["title"] as? [String: Any]
        self.title = titleNotRender?["rendered"] as? String
        let contentNotRender = data?["content"] as? [String: Any]
        self.content = contentNotRender?["rendered"] as? String
//        let links = data?["_links"] as? [String : Any]
//        print(links)
//        let attachementArrayFirst = (links?["wp:featuredmedia"] as? [[String : Any]])?.first
//        print(attachementArrayFirst)
        self.featuredmedia = data?["featured_media"] as? Int
        print(self.featuredmedia)
        
        
        
        
    }
}

class MediaModel {
    var id: Int?
    var image: String?
   


    
    init(data: [String: Any]?) {
        self.id = data?["id"] as? Int
       
        let guidNotRender = data?["guid"] as? [String: Any]
        self.image = guidNotRender?["rendered"] as? String

    }
}
