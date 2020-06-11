//
//  NewsViewModel.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import UIKit

class NewsViewModel: UIView {

    @IBOutlet weak var tableView: UITableView!


}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

}
