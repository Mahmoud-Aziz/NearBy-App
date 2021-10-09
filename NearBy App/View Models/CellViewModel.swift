//
//  CellViewModel.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 09/10/2021.
//

import Foundation
import Kingfisher

class CellViewModel {
    
    let name: String
    let address: String
    let id: String
    let placeCategory: String
    var url: URL?
    var reloadImageView: (() -> ())?
    
    init(name: String, address: String, id: String,placeCategory: String, url: URL? = nil, reloadImageView: (() -> ())? = nil) {
        self.name = name
        self.address = address
        self.id = id
        self.placeCategory = placeCategory
        self.url = url
        self.reloadImageView = reloadImageView
    }
    
    func getPlacePhoto() {
        let request = PhotoRequest()
        request.getPlacePhoto(id: id, { [weak self] response in
            switch response {
            case .success(let photo):
                let item = photo.response?.photos?.items?[0]
                let suffix = item?.suffix
                let prefix = item?.itemPrefix
                let width = item?.width
                let height = item?.height
                guard let prefix = prefix,let suffix = suffix, let width = width, let height = height else { return }
                let urlString = "\(prefix)" + "\(width)x\(height)" + "\(suffix)"
                self?.url = URL(string: urlString)
                self?.reloadImageView?()
                print("Fetched photo successfully")
            case .failure(let error):
                print("Error getting photo \(error.localizedDescription)")
            }
        })
    }
}

