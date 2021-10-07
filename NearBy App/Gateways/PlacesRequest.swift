//
//  PlacesRequest.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation
import Alamofire


class PlacesRequest {
    

        let url = "https://api.foursquare.com/v2/venues/explore?ll=\(latitude),\(longitude)&client_id=\(Constants.client_id)&client_secret=\(Constants.client_secret)&v=\(Constants.v)"
        
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




