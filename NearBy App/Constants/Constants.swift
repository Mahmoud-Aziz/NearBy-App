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
    static let realtimeMood = "Realtime"
    static let singleMood  = "Single Mood"
    static let barButtonTitleKey = "barButtonTitle"
    static let barButtonSavedTitle = UserDefaults.standard.value(forKey: Constants.barButtonTitleKey) as? String
    static let errorMessage = "Something went wrong!"
    static let networkErrorMessage = "No data Found!"
}

