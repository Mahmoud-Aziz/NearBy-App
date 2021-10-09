//
//  MainTableViewDataSource.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: mainViewModelProtocol?
    
    init(viewModel: mainViewModelProtocol?) {
        self.viewModel = viewModel
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.placesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath) as! MainTableViewCell
       let cellViewModel = viewModel?.populateCell(index: indexPath.row)
        cell.viewModel = cellViewModel
        
        return cell
    }
}
