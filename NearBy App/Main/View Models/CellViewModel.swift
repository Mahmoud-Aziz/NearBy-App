//
//  CellViewModel.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 09/10/2021.
//

import Foundation

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
                self?.handleNetworkSuccess(result: photo)
            case .failure(let error):
                self?.handleNetworkFailure(error: error)
            }
        })
    }
    
    private func handleNetworkSuccess(result: Photo) {
        guard let item = result.response?.photos?.items?.first else { return }
        let suffix = item.suffix
        let prefix = item.itemPrefix
        let width = item.width
        let height = item.height
        let urlString = "\(prefix ?? "")" + "\(width ?? 0)x\(height ?? 0)" + "\(suffix ?? "")"
        self.url = URL(string: urlString)
        self.reloadImageView?()
        print("Fetched photo successfully")
    }
    
    private func handleNetworkFailure(error: Error) {
        print("Error getting photo \(error.localizedDescription)")
    }
}

