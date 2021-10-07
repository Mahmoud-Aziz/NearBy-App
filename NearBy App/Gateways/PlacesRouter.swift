//
//  PlacesRouter.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation
import Alamofire

enum PlacesRouter: URLRequestConvertible {
    
    static let baseURL = "https://api.foursquare.com/v2"
    
    case nearbyPaces
    
    var httpMethod: String {
        switch self {
        case .nearbyPaces:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .nearbyPaces:
            return "/venues/explore"
        }
    }
    
    var parameters: [String:Any]? {
        switch self {
        case .nearbyPaces:
            return [
                "near":"Chicago,IL",
                "client_id":"P2ZU2QEY10AW4KEIBO2MZFLK40X5V2FNWKYWVRGIWH1RBIMH",
                "client_secret":"AWSIUJMOKTE3YUKERJ325I2C4EUR0PFMJTPCI4O0MCAJVAEE",
                "v":"20211031"
            ]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .nearbyPaces:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .nearbyPaces:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlString = PlacesRouter.baseURL + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = headers
        return try! encoding.encode(request, with: self.parameters)
    }
}


