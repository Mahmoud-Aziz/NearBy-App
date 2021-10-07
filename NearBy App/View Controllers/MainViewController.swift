//
//  MainViewController.swift
//  NearBy App
//
//  Created by Mahmoud Aziz on 06/10/2021.
//

import UIKit
import CoreLocation
import JGProgressHUD

class MainViewController: UIViewController {
    
    @IBOutlet private weak var realTimeButton: UIBarButtonItem!
    @IBOutlet private weak var mainTableView: UITableView!
    @IBOutlet private weak var errorImage: UIImageView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    var places: [GroupItem]?
    var locationManager: CLLocationManager?
    let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCell()
        configureLocationManager()
        errorLabel.isHidden = true
        errorImage.isHidden = true
        guard let barButtonSavedTitle = Constants.barButtonSavedTitle else {
           return realTimeButton.title = Constants.realtimeMood
        }
        realTimeButton.title = barButtonSavedTitle
    }
    
    @IBAction private func realTimeButtonPressed(_ sender: UIBarButtonItem) {
        hud.show(in: view)
        switch realTimeButton.title {
        case Constants.singleMood:
            sender.title = Constants.realtimeMood
            locationManager?.stopMonitoringSignificantLocationChanges()
            locationManager?.requestLocation()
            handleNetworkBackToWork()
            print("Single Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: "barButtonTitle")
        case Constants.realtimeMood:
            sender.title = Constants.singleMood
            locationManager?.startMonitoringSignificantLocationChanges()
            hud.dismiss(animated: true)
            handleNetworkBackToWork()
            print("Realtime Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: "barButtonTitle")
        default:
            print("")
            hud.dismiss(animated: true)
        }
    }
    
    
    func configureCell() {
        let nib = UINib(nibName: Constants.mainTableViewCellNib, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
        mainTableView.rowHeight = 140
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            hud.show(in: view)
            locationManager?.requestLocation()
        }
    }
    
    func handleError() {
        self.mainTableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        self.errorImage.image = UIImage(named: "cloud-off")
        self.errorLabel.text = Constants.errorMessage
    }
    
    func handleNetworkError() {
        self.mainTableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        self.errorImage.image = UIImage(named: "exclamation")
        self.errorLabel.text = Constants.networkErrorMessage

    }
    
    func handleNetworkBackToWork() {
        mainTableView.isHidden = false
        errorImage.isHidden = true
        errorLabel.isHidden = true
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
        req.retrieveNearbyPlaces(latitude: locationValue.latitude, longitude: locationValue.longitude,{ [weak self] places in
            switch places {
            case .success(let successResults):
                self?.places = successResults.response?.groups?[0].items
                self?.hud.dismiss(animated: true)
                print("Fetched places suscessfully!")
                self?.mainTableView.reloadData()
            case .failure(let error):
                self?.hud.dismiss(animated: true)
                self?.handleNetworkError()
                print(error.localizedDescription)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopMonitoringSignificantLocationChanges()
            print("error retrieving location \(error)")
            handleError()
            return
        }
            handleError()
    }
}

