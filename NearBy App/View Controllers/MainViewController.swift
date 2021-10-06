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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
    }
    
    func configureCell() {
        let nib = UINib(nibName: Constants.mainTableViewCellNib, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath) as! MainTableViewCell
        return cell
    }
    
    
}


extension MainViewController: UITableViewDelegate {
    
}
