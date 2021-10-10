//
//  Photo.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
// MARK: - Welcome
struct Photo: Codable {
    let response: PhotoResponse
}

// MARK: - Response
struct PhotoResponse: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let count: Int?
    let items: [Item]
    let dupesRemoved: Int
}

// MARK: - Item
struct Item: Codable {
    let itemPrefix: String
    let suffix: String
    let width, height: Int

    enum CodingKeys: String, CodingKey {
        case itemPrefix = "prefix"
        case suffix, width, height
    }
}
