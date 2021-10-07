//
//  MainViewController.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import UIKit


class MainViewController: UIViewController {
    
    @IBOutlet private weak var realTimeButton: UIBarButtonItem!
    @IBOutlet private weak var mainTableView: UITableView!
    
    var places: [GroupItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        
        let req = PlacesRequest()
        
        req.retrieveNearbyPlaces({ places in
            switch places {
            case .success(let successResults):
                self.places = successResults.response?.groups?[0].items
                self.mainTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func configureCell() {
        let nib = UINib(nibName: Constants.mainTableViewCellNib, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath) as! MainTableViewCell
        cell.label?.text = self.places?[indexPath.row].venue?.name
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
}
