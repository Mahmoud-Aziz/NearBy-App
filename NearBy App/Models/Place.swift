//
//  Places.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation

// MARK: - Welcome
struct Place: Codable {
//    let meta: Meta?
    let response: Response?

}

// MARK: - Meta
//struct Meta: Codable {
//    let code: Int?
//    let requestID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case code
//        case requestID = "requestId"
//    }
//}

// MARK: - Response
struct Response: Codable {
//    let suggestedFilters: SuggestedFilters?
//    let geocode: Geocode?
//    let headerLocation, headerFullLocation, headerLocationGranularity: String?
//    let totalResults: Int?
//    let suggestedBounds: Bounds?
    let groups: [Group]?
}

// MARK: - Geocode
//struct Geocode: Codable {
//    let what, geocodeWhere: String?
//    let center: Center?
//    let displayString: String?
//    let cc: Cc?
//    let geometry: Geometry?
//    let slug, longID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case what
//        case geocodeWhere = "where"
//        case center, displayString, cc, geometry, slug
//        case longID = "longId"
//    }
//}
//
//enum Cc: String, Codable {
//    case eg = "EG"
//}

// MARK: - Center
//struct Center: Codable {
//    let lat, lng: Double?
//}

// MARK: - Geometry
//struct Geometry: Codable {
//    let bounds: Bounds?
//}

// MARK: - Bounds
//struct Bounds: Codable {
//    let ne, sw: Center?
//}

// MARK: - Group
struct Group: Codable {
//    let type, name: String?
    let items: [GroupItem]?
}

// MARK: - GroupItem
struct GroupItem: Codable {
//    let reasons: Reasons?
    let venue: Venue?
//    let referralID: String?
//    let flags: Flags?

    enum CodingKeys: String, CodingKey {
//        case reasons
        case venue
//        case referralID = "referralId"
//        case flags
    }
}

// MARK: - Flags
struct Flags: Codable {
    let outsideRadius: Bool?
}

// MARK: - Reasons
struct Reasons: Codable {
//    let count: Int?
//    let items: [ReasonsItem]?
}

// MARK: - ReasonsItem
struct ReasonsItem: Codable {
//    let summary: Summary?
//    let type: TypeEnum?
//    let reasonName: ReasonName?
}

//enum ReasonName: String, Codable {
//    case globalInteractionReason = "globalInteractionReason"
//}
//
//enum Summary: String, Codable {
//    case thisSpotIsPopular = "This spot is popular"
//}
//
//enum TypeEnum: String, Codable {
//    case general = "general"
//}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String?
    let location: Location?

//    let photos: Photos?
//    let venuePage: VenuePage?
}

// MARK: - Category


// MARK: - Icon
//struct Icon: Codable {
//    let iconPrefix: String?
//    let suffix: Suffix?
//
//    enum CodingKeys: String, CodingKey {
//        case iconPrefix = "prefix"
//        case suffix
//    }
//}
//
//enum Suffix: String, Codable {
//    case png = ".png"
//}

// MARK: - Location
struct Location: Codable {
    let address: String?
    let lat, lng: Double?
    let labeledLatLngs: [LabeledLatLng]?
    let postalCode: String?
//    let cc: Cc?
    let city: String?
//    let state: State?
//    let country: Country?
    let formattedAddress: [String]?
    let crossStreet, neighborhood: String?
}

//enum Country: String, Codable {
//    case مصر = "مصر"
//}

// MARK: - LabeledLatLng
struct LabeledLatLng: Codable {
//    let label: Label?
    let lat, lng: Double?
}

//enum Label: String, Codable {
//    case display = "display"
//}

//enum State: String, Codable {
//    case cairoGovernate = "Cairo Governate"
//    case cairoGovernorate = "Cairo Governorate"
//    case القاهرة = "القاهرة"
//}

//struct SuggestedFilters: Codable {
//    let header: String?
//    let filters: [Filter]?
//}
//
//// MARK: - Filter
//struct Filter: Codable {
//    let name, key: String?
//}
