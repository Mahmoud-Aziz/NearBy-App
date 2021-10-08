//
//  PhotoRequest.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
import Alamofire

class PhotoRequest {
    
    func getPlacePhoto(id: String, _ completion: @escaping (Swift.Result<Photo, Error>) -> Void) {
        
        let router = PlacesRouter.placePhoto(id: id)
        
        Alamofire.request(router).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let placePhoto = try jsonDecoder.decode(Photo.self, from: jsonData)
                        completion(.success(placePhoto))
                    } catch let error {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
