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
    private var viewModel: MainViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MainViewModel()
        
        mainTableViewDataSource = MainTableViewDataSource(viewModel: viewModel)
        mainTableView.dataSource = mainTableViewDataSource
        
        viewModel?.locationManager = CLLocationManager()
        viewModel?.configureLocationManager()
        
        viewModel?.setLocationManagerDelegate()
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

    private func setViewModelClosures() {
        reloadTableView()
        showSpinner()
        hideSpinner()
        handleNetworkErrorViewModel()
    }
    
    //MARK: Handle errors methods

    private func handleNetworkError() {
        self.mainTableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        self.errorImage.image = UIImage(named: Constants.networkErrorImage)
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
    
    private func handleError() {
        self.viewModel?.handleError = { [weak self] in
            self?.mainTableView.isHidden = true
            self?.errorLabel.isHidden = false
            self?.errorImage.isHidden = false
            self?.errorImage.image = UIImage(named: Constants.errorImage)
            self?.errorLabel.text = Constants.errorMessage
        }
    }
}
