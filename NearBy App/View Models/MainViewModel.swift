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
    func getPhotoURL() -> String
    func requestLocation()
}

class MainViewModel {
    var locationManager: CLLocationManager?
    private var places: [GroupItem] = []
    private var photoPrefix: String?
    private var photoSuffix: String?
    private var photoWidth: Int?
    private var photoHeight: Int?
    private var photoURL: String?
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
                self.getPlacePhoto(id: places[0].venue?.id ?? "No ID")
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
    
    func getPlacePhoto(id: String) {
        let request = PhotoRequest()
        request.getPlacePhoto(id: id, { [weak self] response in
            switch response {
            case .success(let photo):
                guard let self = self else { return }
                guard let suffix = photo.response?.photos?.items?[0].suffix,
                      let prefix = photo.response?.photos?.items?[0].itemPrefix,
                      let width = photo.response?.photos?.items?[0].width,
                      let height = photo.response?.photos?.items?[0].height else { return }
                
                self.photoSuffix = suffix
                self.photoPrefix = prefix
                self.photoWidth = width
                self.photoHeight = height
                
                let photoURL = self.createPhotoURL(suffix: suffix, prefix: prefix, width: width, height: height)
                self.photoURL = photoURL
                self.reloadMainTableView?()
                print("Fetched photo \(photo)")
            case .failure(let error):
                print("Error getting photo \(error.localizedDescription)")
            }
        })
    }
    
    func createPhotoURL(suffix:String, prefix:String, width: Int, height:Int) -> String {
        return "\(prefix)" + "\(width)x\(height)" + "\(suffix)"
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
    
    func getPhotoURL() -> String {
        photoURL ?? ""
    }
}
