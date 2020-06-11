//
//  RadioVerstaViewController.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import UIKit
import MBProgressHUD
import UIColor_Hex_Swift
import EmptyDataSet_Swift

class RadioVerstaViewController: UIViewController {
    
    
    
    //MARK: Show Activity Indicator
     func showSpinner() {
         //MBProgressHUD.showAdded(to: view, animated: true)
         
        let spinner  = MBProgressHUD.showAdded(to: view, animated: true)
         spinner.backgroundView.color = UIColor.lightGray
         spinner.backgroundView.style = .solidColor
         spinner.backgroundView.alpha = 0.4
         spinner.bezelView.color = UIColor.clear
         spinner.bezelView.style = .solidColor
        
             //MBProgressHUD.showAdded(to: view, animated: true)
             
         
     }
     
    //MARK: Hide Activity Indicator
     func hideSpinner() {
         MBProgressHUD.hide(for: view, animated: true)
     }
    
    func showAlertWithOK(title: String, msg: String) {
        let action = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithClosure(title: String, msg: String, btnTitle: String, closure: @escaping (()->())) {
        let action = UIAlertAction(title: btnTitle, style: .default) { (_) in
            closure()
        }
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func showAlertNoInternet(closure: @escaping (()->())){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: "Отсутствует интернет соединение", preferredStyle: .alert)
            let action = UIAlertAction(title: "Повторить запрос", style: .default) { (_) in
                closure()
                
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    //MARK: - EMPTY TABLE SETUP
    func emptyTableSetup(message: String, buttonTitle: String, tableView: UITableView, closure: @escaping (()->())) {
        // create attributed string
        let emptyTitle = "Нет данных"
        let emptyAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyAttrString = NSAttributedString(string: emptyTitle, attributes: emptyAttribute)
        
        let emptyDescTitle = message
        let emptyDescAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#333333") ]
        let emptyDescAttrString = NSAttributedString(string: emptyDescTitle, attributes: emptyDescAttribute)
        
        let buttonTitle = buttonTitle
        let buttonAttribute = [ NSAttributedString.Key.foregroundColor: UIColor("#FF4848") ]
        let buttonAttrString = NSAttributedString(string: buttonTitle, attributes: buttonAttribute)
        
        
        
        
        tableView.emptyDataSetView { view in
            view.titleLabelString(emptyAttrString)
                .detailLabelString(emptyDescAttrString)
                .shouldFadeIn(true)
                .buttonTitle(buttonAttrString, for: .normal)
                .shouldFadeIn(true)
                .isScrollAllowed(true)
                .isTouchAllowed(true)
                .didTapDataButton {
                    print("reload")
                    closure()
                    
                    
            }
        }
    }
    
    func loadMedia(mediaID: Int?, closure: @escaping (([String : Any])->())) {
        guard let mediaID = mediaID else {
            return
        }
        let apiManager = API()
        apiManager.getMedia(mediaId: mediaID) { (data, result) in
            switch result {
            case .success:
                self.hideSpinner()
                
                if let _data = data {
                    
                    closure(_data)
                }

                
            default:
                self.showSpinner()
                break
                
            }

        }
    }
    

}
