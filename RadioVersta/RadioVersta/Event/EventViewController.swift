//
//  EventViewController.swift
//  RadioVersta
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//  Copyright © 2020 WolfStudio. All rights reserved.
//

import UIKit

class EventViewController: RadioVerstaViewController, EventModelDelegate {

    @IBOutlet var viewModel: EventViewModel!
    
    let eventModel = EventModel()
    var eventArray = [[String: Any]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventModel.getPostLists { (data) in
            print(data)
            self.eventArray = data
            self.viewModel.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventModel.delegate = self
        viewModel.tableView.delegate = self
        viewModel.tableView.dataSource = self
        viewModel.tableView.tableFooterView = UIView()
        emptyTableSetup(message: "Пока нет новостей", buttonTitle: "Обновить", tableView: viewModel.tableView) {
            self.eventModel.getPostLists { (data) in
                print(data)
                self.eventArray = data
                self.viewModel.tableView.reloadData()
            }
        }
        
        eventModel.getPostLists { (data) in
            print(data)
            self.eventArray = data
            self.viewModel.tableView.reloadData()
        }
    }
    



}

extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        let dict = PostModel(data: eventArray[indexPath.row])
        
        loadMedia(mediaID: dict.featuredmedia) { (data) in
            let imageInfo = MediaModel(data: data)
            if let imageString = imageInfo.image {
                let encodedUrl = imageString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                cell.imageThumb.sd_setImage(with: URL(string: encodedUrl ?? ""), completed: nil)
            }
        }
        
        cell.titleLabel.text = dict.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = PostModel(data: eventArray[indexPath.row])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            detailVC.information = dict
            self.navigationController?.pushViewController(detailVC, animated: true)

        }
    }
    
}
