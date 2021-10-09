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
}

struct NetworkConstants {
    static let version = "20211031"
    static let accuracy = "10000.0"
}

