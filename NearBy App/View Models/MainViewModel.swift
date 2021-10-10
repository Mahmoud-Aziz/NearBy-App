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
    var handleError: (() -> ())? { get set }

    
    func configureLocationManager()
    func getNearbyPlaces(latitude: Double, longitude: Double)
    func placesCount() -> Int?
    func requestLocation()
    func populateCell(index: Int) -> CellViewModel
    func setLocationManagerDelegate()
}

class MainViewModel: NSObject {
    var locationManager: CLLocationManager?
    private var places: [GroupItem] = []
    private var categories: [Category] = []
    var reloadMainTableView: (() -> ())?
    var showSpinner: (() -> ())?
    var hideSpinner: (() -> ())?
    var handleNetworkErrorViewModel: (() -> ())?
    var handleError: (() -> ())?

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
    
    func setLocationManagerDelegate() {
        locationManager?.delegate = self
    }

}

extension MainViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        guard let location: CLLocationCoordinate2D = lastLocation?.coordinate else { return }
        let latitude = location.latitude
        let longitude = location.longitude
        print("locations = \(latitude) \(longitude)")
        self.getNearbyPlaces(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopMonitoringSignificantLocationChanges()
            print("Error fetching location \(error)")
            self.handleError?()
            return
        }
        self.handleError?()
    }
}
