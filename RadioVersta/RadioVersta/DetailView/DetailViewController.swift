//
//  DetailViewController.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage

class DetailViewController: RadioVerstaViewController, WKNavigationDelegate {

    var information: PostModel?
    @IBOutlet var viewModel: DetailViewModel!
    @IBOutlet weak var webView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMedia(mediaID: information?.featuredmedia) { (data) in
            let imageInfo = MediaModel(data: data)
            if let imageString = imageInfo.image {
                let encodedUrl = imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                self.viewModel.postTumb.sd_setImage(with: URL(string: encodedUrl ?? ""), completed: nil)
            }
            
            
        }
       // viewModel.postTumb.sd_setImage(with: URL(string: urlString), completed: nil)
        viewModel.titleLabel.text = information?.title
        webView.navigationDelegate = self
        webView.configuration.preferences.javaScriptEnabled = true
       
        webView.loadHTMLString("<html><body><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0,Proxima Nova-Regular\">\(information?.content ?? "")</body></html>", baseURL: nil)
        

    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        guard navigationAction.navigationType == .other || navigationAction.navigationType == .reload  else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }


    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
