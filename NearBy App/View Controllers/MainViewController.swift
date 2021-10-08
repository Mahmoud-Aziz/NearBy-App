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
    
    private let hud = JGProgressHUD(style: .dark)
    private var mainTableViewDataSource: MainTableViewDataSource?
    private var viewModel: mainViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel()
        
        mainTableViewDataSource = MainTableViewDataSource(viewModel: viewModel)
        mainTableView.dataSource = mainTableViewDataSource
        
        viewModel?.locationManager = CLLocationManager()
        viewModel?.configureLocationManager()
        
        setLocationManagerDelegate()
        viewModel?.requestLocation()

        setViewModelClosures()
        configureMainTableViewCell()
        setInitialUiState()
        setBarButtonDefaultTitle()
    }
    
    //MARK: Helpers methods
    
    private func setBarButtonDefaultTitle() {
        guard let barButtonSavedTitle = Constants.barButtonSavedTitle else {
            return realTimeButton.title = Constants.realtimeMood
        }
        realTimeButton.title = barButtonSavedTitle
    }
    
    private func configureMainTableViewCell() {
        let nib = UINib(nibName: Constants.mainTableViewCellNib, bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
        mainTableView.rowHeight = 140
    }
    
    private func setInitialUiState() {
        errorLabel.isHidden = true
        errorImage.isHidden = true
    }
    
    private func setLocationManagerDelegate() {
        viewModel?.locationManager?.delegate = self
    }
    
    private func setViewModelClosures() {
        reloadTableView()
        showSpinner()
        hideSpinner()
        handleNetworkErrorViewModel()
    }
    
    //MARK: Handle errors methods
    
    private func handleError() {
        self.mainTableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        self.errorImage.image = UIImage(named: "cloud-off")
        self.errorLabel.text = Constants.errorMessage
    }
    
    private func handleNetworkError() {
        self.mainTableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        self.errorImage.image = UIImage(named: "exclamation")
        self.errorLabel.text = Constants.networkErrorMessage
        
    }
    
    private func handleNetworkBackToWork() {
        mainTableView.isHidden = false
        errorImage.isHidden = true
        errorLabel.isHidden = true
    }
    
    //MARK: Bar button item toggle action
    
    @IBAction private func realTimeButtonPressed(_ sender: UIBarButtonItem) {
        hud.show(in: view)
        switch realTimeButton.title {
        case Constants.singleMood:
            sender.title = Constants.realtimeMood
            viewModel?.locationManager?.stopMonitoringSignificantLocationChanges()
            viewModel?.locationManager?.requestLocation()
            handleNetworkBackToWork()
            print("Single Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: Constants.barButtonTitleKey)
        case Constants.realtimeMood:
            sender.title = Constants.singleMood
            viewModel?.locationManager?.startMonitoringSignificantLocationChanges()
            hud.dismiss(animated: true)
            handleNetworkBackToWork()
            print("Realtime Mood Activated")
            UserDefaults.standard.set(sender.title, forKey: Constants.barButtonTitleKey)
        default:
            print("")
            hud.dismiss(animated: true)
        }
    }
}


//MARK: Location Manager delegate methods

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        guard let location: CLLocationCoordinate2D = lastLocation?.coordinate else { return }
        let latitude = location.latitude
        let longitude = location.longitude
        print("locations = \(latitude) \(longitude)")
        viewModel?.getNearbyPlaces(latitude: 48.8566, longitude: 2.3522)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            manager.stopMonitoringSignificantLocationChanges()
            print("Error fetching location \(error)")
            handleError()
            return
        }
        handleError()
    }
}

extension MainViewController {
    
    //MARK: ViewModel closures implementation
    
    private func reloadTableView() {
        self.viewModel?.reloadMainTableView = {[weak self] in
            self?.mainTableView.reloadData()
        }
    }
    
    private func showSpinner() {
        self.viewModel?.showSpinner = { [weak self] in
            guard let self = self else { return }
            self.hud.show(in: self.view)
        }
    }
    
    private func hideSpinner() {
        self.viewModel?.hideSpinner = { [weak self] in
            self?.hud.dismiss(animated: true)
        }
    }
    
    private func handleNetworkErrorViewModel() {
        self.viewModel?.handleNetworkErrorViewModel  = { [weak self] in
            self?.handleNetworkError()
            self?.hud.dismiss(animated: true)
        }
    }
}
