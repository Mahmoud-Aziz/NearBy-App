//
//  JSONDecoder + Extention.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation
import Alamofire

extension JSONDecoder {
    
  func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
    guard response.error == nil else {
      print(response.error!)
      return .failure(response.error!)
    }

    guard let responseData = response.data else {
      print("didn't get any data from API")
        return .failure(response.error!)
    }

    do {
      let item = try decode(T.self, from: responseData)
      return .success(item)
    } catch {
      print("error trying to decode response")
      print(error)
      return .failure(error)
    }
  }
}
