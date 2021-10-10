//
//  MainViewModel.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 08/10/2021.
//

import Foundation
import CoreLocation

protocol MainViewModelProtocol {
    var locationManager: CLLocationManager? { get set }
    var reloadMainTableView: (() -> ())? { get set }
    var showSpinner: (() -> ())? { get set }
    var hideSpinner: (() -> ())? { get set }
    var handleNetworkErrorViewModel: (() -> ())? { get set }
    
    func configureLocationManager()
    func getNearbyPlaces(latitude: Double, longitude: Double)
    func placesCount() -> Int?
    func requestLocation()
    func populateCell(index: Int) -> CellViewModel
}

class MainViewModel {
    var locationManager: CLLocationManager?
    private var places: [GroupItem] = []
    private var categories: [Category] = []
    var reloadMainTableView: (() -> ())?
    var showSpinner: (() -> ())?
    var hideSpinner: (() -> ())?
    var handleNetworkErrorViewModel: (() -> ())?
}

//MARK: Main View Model Protocol Conformance

extension MainViewModel: MainViewModelProtocol {
    
    func configureLocationManager() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
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
                 let places = successResults.response.groups[0].items
                 let categories = places[0].venue.categories
                guard let self = self else { return }
                self.places = places
                self.categories = categories
                self.hideSpinner?()
                self.reloadMainTableView?()
                print("Fetched places suscessfully from Foursquare API!")
            case .failure(let error):
                guard let self = self else { return }
                self.hideSpinner?()
                self.handleNetworkErrorViewModel?()
                print("Network Error: \(error.localizedDescription)")
            }
        })
    }
    
    func placesCount() -> Int? {
        return self.places.count
    }
    
    private func place(index: Int) -> GroupItem {
        places[index]
    }
    
    func populateCell(index: Int) -> CellViewModel {
        let place = self.place(index: index)
        let name = place.venue.name
        let address = place.venue.location.address
        let id = place.venue.id
        let shortName = place.venue.categories[0].shortName
        let cellViewModel = CellViewModel(name: name, address: address, id: id, placeCategory: shortName)
        return cellViewModel
    }
}
