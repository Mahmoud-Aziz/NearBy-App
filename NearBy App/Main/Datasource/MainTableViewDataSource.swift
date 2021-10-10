//
//  MainTableViewDataSource.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
import UIKit

class MainTableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: MainViewModelProtocol?
    
    init(viewModel: MainViewModelProtocol?) {
        self.viewModel = viewModel
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = self.viewModel?.placesCount() else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath) as! MainTableViewCell
       let cellViewModel = viewModel?.populateCell(index: indexPath.row)
        cell.viewModel = cellViewModel
        
        return cell
    }
}
