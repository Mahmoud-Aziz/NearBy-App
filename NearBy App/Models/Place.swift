//
//  Places.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation

// MARK: - Welcome
struct Place: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let groups: [Group]
}

// MARK: - Group
struct Group: Codable {
    let items: [GroupItem]
}

// MARK: - GroupItem
struct GroupItem: Codable {
    let venue: Venue
}
    enum CodingKeys: String, CodingKey {
        case venue
    }

// MARK: - Flags
struct Flags: Codable {
    let outsideRadius: Bool
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String
    let location: Location
    let categories: [Category]
}
// MARK: - Category
struct Category: Codable {
    let shortName: String
}

// MARK: - Location
struct Location: Codable {
    let address: String
    let lat, lng: Double
    let labeledLatLngs: [LabeledLatLng]
    let postalCode: String
    let city: String
    let formattedAddress: [String]
    let crossStreet, neighborhood: String?
}

// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
    let lat, lng: Double
}
