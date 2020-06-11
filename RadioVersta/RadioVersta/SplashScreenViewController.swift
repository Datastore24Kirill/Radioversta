//
//  ViewController.swift
//  РадиоВерста
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {

               self.logoImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        }, completion: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as? UIViewController {

            self.navigationController?.pushViewController(tabBarVC, animated: true)

        }
       
        

    }

}

