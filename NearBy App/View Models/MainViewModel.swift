//
//  MainViewModel.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
import CoreLocation

protocol mainViewModelProtocol {
    var locationManager: CLLocationManager? { get set }
    var reloadMainTableView: (() -> ())? { get set }
    var showSpinner: (() -> ())? { get set }
    var hideSpinner: (() -> ())? { get set }
    var handleNetworkErrorViewModel: (() -> ())? { get set }
    var handleErrorViewModel: (() -> ())? { get set }
    
    func configureLocationManager()
    func getNearbyPlaces(latitude: Double, longitude: Double)
    func placesCount() -> Int?
    func place(index: Int) -> GroupItem
}

class MainViewModel {
    var locationManager: CLLocationManager?
    var places: [GroupItem] = []
    var reloadMainTableView: (() -> ())?
    var showSpinner: (() -> ())?
    var hideSpinner: (() -> ())?
    var handleNetworkErrorViewModel: (() -> ())?
    var handleErrorViewModel: (() -> ())?
}


extension MainViewModel: mainViewModelProtocol {
    
    func configureLocationManager() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            showSpinner?()
            locationManager?.requestLocation()
        }
    }
    
    func getNearbyPlaces(latitude: Double, longitude: Double) {
        let request = PlacesRequest()
        request.getNearbyPlaces(latitude: latitude, longitude: longitude,{ [weak self] places in
            switch places {
            case .success(let successResults):
                guard let places = successResults.response?.groups?[0].items else {
                    return
                }
                self?.places = places
                self?.hideSpinner?()
                self?.reloadMainTableView?()
                print("Fetched places suscessfully from Foursquare API!")
            case .failure(let error):
                self?.hideSpinner?()
                self?.handleNetworkErrorViewModel?()
                print(error.localizedDescription)
            }
        })
    }
    
    func placesCount() -> Int? {
        self.places.count
    }
    
    func place(index: Int) -> GroupItem {
        places[index]
    }
    
}
