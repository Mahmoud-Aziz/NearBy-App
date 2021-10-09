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
    
    func configureLocationManager()
    func getNearbyPlaces(latitude: Double, longitude: Double)
    func placesCount() -> Int?
    func place(index: Int) -> GroupItem
    func venueID(index: Int) -> String
    func getPhotoURL() -> Item
    func requestLocation()
    func populateCell(index: Int) -> CellViewModel
}

class MainViewModel {
    var locationManager: CLLocationManager?
    private var places: [GroupItem] = []
    private var item : Item?
    var reloadMainTableView: (() -> ())?
    var showSpinner: (() -> ())?
    var hideSpinner: (() -> ())?
    var handleNetworkErrorViewModel: (() -> ())?
}


extension MainViewModel: mainViewModelProtocol {
 
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
                guard let places = successResults.response?.groups?[0].items else {
                    return
                }
                guard let self = self else { return }
                self.places = places
                self.hideSpinner?()
                self.reloadMainTableView?()
                print("Fetched places suscessfully from Foursquare API!")
            case .failure(let error):
                guard let self = self else { return }
                self.hideSpinner?()
                self.handleNetworkErrorViewModel?()
                print(error.localizedDescription)
            }
        })
    }
    
    
    
    func placesCount() -> Int? {
        print("places.count \(places.count)")
        return self.places.count
    }
    
    func place(index: Int) -> GroupItem {
        places[index]
    }
    
    func venueID(index: Int) -> String {
        places[index].venue?.id ?? ""
    }
    
    func getPhotoURL() -> Item {
        self.item ?? Item(itemPrefix: "https://igx.4sqi.net/img/general/", suffix: "/5163668_xXFcZo7sU8aa1ZMhiQ2kIP7NllD48m7qsSwr1mJnFj4.jpg", width: 300, height: 500)
    }
    
    func populateCell(index: Int) -> CellViewModel {
        let place = self.place(index: index)
        let cellViewModel = CellViewModel(name: place.venue?.name ?? "", address: place.venue?.location?.address ?? "", id: place.venue?.id ?? "")
        return cellViewModel
    }

}
