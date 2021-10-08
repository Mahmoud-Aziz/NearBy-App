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
        
        let url = "https://api.foursquare.com/v2/venues/explore?ll=\(latitude),\(longitude)&client_id=\(NetworkConstants.client_id)&client_secret=\(NetworkConstants.client_secret)&v=\(NetworkConstants.v)&llAcc=\(NetworkConstants.llAcc)"
        
        Alamofire.request(url).responseJSON(completionHandler: { response in
            switch response.result {
            case .success:
                if let jsonData = response.data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let nearbyPlaces = try jsonDecoder.decode(Place.self, from: jsonData)
                        completion(.success(nearbyPlaces))
                    }catch let error {
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




