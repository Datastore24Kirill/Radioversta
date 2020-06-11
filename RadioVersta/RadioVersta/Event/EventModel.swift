//
//  EventModel.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import Foundation

protocol EventModelDelegate {
    func showSpinner()
    func hideSpinner()
    func showAlertNoInternet(closure: @escaping (()->()))
    func showAlertWithOK(title: String, msg: String)

}

class EventModel {
    var delegate: EventModelDelegate?
    let apiManager = API()
    
    func getPostLists(closure: @escaping (([[String: Any]])->())) {
        self.delegate?.showSpinner()
      
        apiManager.getEventList() { (data, result) in
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
