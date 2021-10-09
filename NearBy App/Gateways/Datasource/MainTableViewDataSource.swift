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
        viewModel?.getPlacePhoto(id: viewModel?.venueID(index: indexPath.row) ?? "")
        cell.photo = viewModel?.getPhotoURL()
        cell.placeNamelabel?.text = viewModel?.place(index: indexPath.row).venue?.name
        cell.placeAddressLabel?.text = viewModel?.place(index: indexPath.row).venue?.location?.address
        return cell
    }
}
