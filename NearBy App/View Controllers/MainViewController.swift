//
//  MainViewController.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet private weak var realTimeButton: UIBarButtonItem!
    @IBOutlet private weak var mainTableView: UITableView!
    
    var places: [GroupItem]?
    var locationManager: CLLocationManager?
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        configureLocationManager()
        
        guard let barButtonSavedTitle = Constants.barButtonSavedTitle else {
           return realTimeButton.title = Constants.realtimeMood
        }
        realTimeButton.title = barButtonSavedTitle
    }
    
    @IBAction private func realTimeButtonPressed(_ sender: UIBarButtonItem) {
        switch realTimeButton.title {
        case Constants.singleMood:
            sender.title = Constants.realtimeMood
            locationManager?.stopMonitoringSignificantLocationChanges()
            locationManager?.requestLocation()
            print("Single Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: "barButtonTitle")
        case Constants.realtimeMood:
            sender.title = Constants.singleMood
            locationManager?.startMonitoringSignificantLocationChanges()
            print("Realtime Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: "barButtonTitle")
        default:
            print("")
        }
    }
    
    
    func configureCell() {
        let nib = UINib(nibName: Constants.mainTableViewCellNib, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.requestLocation()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.mainTableViewCellIdentifier, for: indexPath) as! MainTableViewCell
        cell.label?.text = self.places?[indexPath.row].venue?.name
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    
}

//MARK: Location Manager delegate methods

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last
        
        guard let locationValue: CLLocationCoordinate2D = lastLocation?.coordinate else
        { return }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
        
        let req = PlacesRequest()
        
        req.retrieveNearbyPlaces(latitude: locationValue.latitude, longitude: locationValue.longitude,{ places in
            switch places {
            case .success(let successResults):
                self.places = successResults.response?.groups?[0].items
                print("Fetched places suscessfully!")
                self.mainTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopMonitoringSignificantLocationChanges()
            print("error retrieving location \(error)")
            
            return
        }
        // Notify the user of any errors.
    }
}

