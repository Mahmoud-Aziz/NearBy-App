//
//  MainTableViewCell.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import UIKit
import Kingfisher

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeNamelabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet private weak var placeImageView: UIImageView!
    
    var photo: Item? {
        didSet {
            guard let suffix = photo?.suffix,
                  let prefix = photo?.itemPrefix,
                  let width = photo?.width,
                  let height = photo?.height else { return }
            let urlString = "\(prefix)" + "\(width)x\(height)" + "\(suffix)"
            self.placeImageView.kf.setImage(with: URL(string: urlString))
        }
    }
}
