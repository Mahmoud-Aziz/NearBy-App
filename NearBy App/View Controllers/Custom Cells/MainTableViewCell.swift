//
//  MainTableViewCell.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var placeNamelabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var placeImageView: UIImageView!
    
    var viewModel: CellViewModel? {
        didSet {
            viewModel?.reloadImageView = { [weak self] in
                self?.placeImageView.kf.setImage(with: self?.viewModel?.url, placeholder: UIImage(named: "photo-placeholder"))
            }
            viewModel?.getPlacePhoto()
            placeNamelabel.text = viewModel?.name
            placeAddressLabel.text = viewModel?.address
        }
    }
    
    override func prepareForReuse() {
        placeImageView.image = UIImage(named: "photo-placeholder")
    }
}
