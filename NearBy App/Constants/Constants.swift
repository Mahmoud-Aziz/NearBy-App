//
//  Constants.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import Foundation

struct Constants {
    static let mainTableViewCellNib = "MainTableViewCell"
    static let mainTableViewCellIdentifier = "MainTableViewCell"
    static let realtimeMood = "Realtime Mode"
    static let singleMood  = "Single Mode"
    static let barButtonTitleKey = "barButtonTitle"
    static let barButtonSavedTitle = UserDefaults.standard.value(forKey: Constants.barButtonTitleKey) as? String
    static let errorMessage = "Something went wrong!"
    static let networkErrorMessage = "No data Found!"
    static let photoPlaceholder = "photo-placeholder"
    static let errorImage = "cloud-off"
    static let networkErrorImage = "exclamation"
}

struct NetworkConstants {
    static let version = "20211031"
    static let accuracy = "10000.0"
    static let baseURL = "https://api.foursquare.com/v2"
    static let git = "GET"
    static let nearbyPlacesEndPoint = "/venues/explore"
}

