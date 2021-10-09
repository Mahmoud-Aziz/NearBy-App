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
    var url: URL?
    var reloadImageView: (() -> ())?
    
     init(name: String, address: String, id: String, url: URL? = nil, reloadImageView: (() -> ())? = nil) {
        self.name = name
        self.address = address
        self.id = id
        self.url = url
        self.reloadImageView = reloadImageView
    }
    
    func getPlacePhoto() {
        let request = PhotoRequest()
        request.getPlacePhoto(id: id, { [weak self] response in
            switch response {
            case .success(let photo):
                
                guard let suffix = photo.response?.photos?.items?[0].suffix,
                              let prefix = photo.response?.photos?.items?[0].itemPrefix,
                              let width = photo.response?.photos?.items?[0].width,
                              let height = photo.response?.photos?.items?[0].height else { return }
                let urlString = "\(prefix)" + "\(width)x\(height)" + "\(suffix)"
                self?.url = URL(string: urlString)
                self?.reloadImageView?()
                print("Fetched photo \(photo)")
            case .failure(let error):
                print("Error getting photo \(error.localizedDescription)")
            }
        })
    }
}

