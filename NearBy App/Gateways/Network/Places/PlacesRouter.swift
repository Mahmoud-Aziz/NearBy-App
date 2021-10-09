//
//  PlacesRouter.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation
import Alamofire

enum PlacesRouter: URLRequestConvertible {
    
    static let baseURL = NetworkConstants.baseURL
    case nearbyPaces(latitude: Double, longitude: Double)
    case placePhoto(id: String)
    
    var httpMethod: String {
        switch self {
        case .nearbyPaces:
            return NetworkConstants.get
        case .placePhoto:
            return NetworkConstants.get
        }
    }
    
    var path: String {
        switch self {
        case .nearbyPaces:
            return NetworkConstants.nearbyPlacesEndPoint
        case let .placePhoto(id):
            return "/venues/\(id)/photos"
        
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case let .nearbyPaces(latitude, longitude):
            return requestPlacesParameters(latitude: latitude, longitude: longitude)
        case .placePhoto:
            return requestPhotoParameters()
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .nearbyPaces:
            return [:]
        case .placePhoto:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .nearbyPaces:
            return JSONEncoding.default
        case .placePhoto:
            return JSONEncoding.default
        }
    }
    
    private func requestPlacesParameters(latitude: Double, longitude: Double) -> [String: Any] {
        return [
            "near":"\(latitude),\(longitude)",
            "client_id":"\(APISecretConstant.clientID)",
            "client_secret":"\(APISecretConstant.clientSecret)",
            "v":"\(NetworkConstants.version)",
            "llAcc":"\(NetworkConstants.accuracy)"
            ]
    }
    
    private func requestPhotoParameters() -> [String: Any] {
        return [
            "client_id":"\(APISecretConstant.clientID)",
            "client_secret":"\(APISecretConstant.clientSecret)",
            "v":"\(NetworkConstants.version)",
            ]
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlString = PlacesRouter.baseURL + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        return try! URLEncoding.default.encode(request, with: self.parameters)
    }
}


