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
    
    var photoURL: String? {
        didSet {
            self.placeImageView.kf.setImage(with: URL(string: photoURL ?? ""))
        }
    }
}
