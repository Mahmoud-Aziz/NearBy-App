//
//  PlacesRequest.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation
import Alamofire

class PlacesRequest {
    
    func getNearbyPlaces(latitude: Double, longitude: Double, _ completion: @escaping (Swift.Result<Place, Error>) -> Void) {
        
        let router = PlacesRouter.nearbyPaces(latitude: latitude, longitude: longitude)
        
        Alamofire.request(router).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let nearbyPlaces = try jsonDecoder.decode(Place.self, from: jsonData)
                        completion(.success(nearbyPlaces))
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




