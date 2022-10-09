//
//  ViewController.swift
//  Weather App
//
//  Created by Kato Drake Smith on 04/10/2022.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //MARK: - Propeties
    let reachability = try! Reachability()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    private var tableView: UITableView!
    var forecastModel = [WeatherData]()
    var cityName = ""
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.backgroundColor = .white
        button.setImage(UIImage(named: "like_filled"), for: .normal)
        button.addTarget(self, action: #selector(fabTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged,object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            setUpLocation()
        case .cellular:
            setUpLocation()
        case .unavailable:
            self.view.makeToast(AppMessages.unavailable, duration: 3.0, position: .top)
            getSavedData()
        case .none:
            self.view.makeToast(AppMessages.noConnection, duration: 3.0, position: .top)
            getSavedData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        forecastModel.removeAll()
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name:
                .reachabilityChanged, object: reachability)
    }
    
    //MARK: - Selectors
    @objc func fabTapped() {
        OfflineData.shared.createCity(name: cityName) { message in
            self.view.makeToast(message, duration: 3.0, position: .bottom)
        }
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        let displayWidth: CGFloat = self.view.frame.width
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: UIScreen.main.bounds.size.height))
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        navigationItem.title = "Current Weather Location"
        view.addSubview(actionButton)
        actionButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
            paddingBottom: 64, paddingRight: 16,
            width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        actionButton.isHidden = true
    }
    
    
    //MARK: - Location
    func setUpLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            getLocation()
            return
        }
        self.view.makeToast("Turn On Location", duration: 3.0, position: .top)
    }
    
    func getLocation() {
        ERProgressHud.sharedInstance.show(withTitle: AppMessages.load)
        guard let currentLocation = currentLocation else {return}
        NetworkService.shared.fetchCurrentWeatherData(for: currentLocation) {
            currentResponse, error in
            if error == nil {
                NetworkService.shared.fetchForecastWeatherData(for: currentLocation) {
                    weeklyResponse, error in
                    if error == nil {
                        OfflineData.shared.saveCurrentWeather(currentWeather: currentResponse!)
                        OfflineData.shared.saveWeeklyWeather(weeklyWeather: weeklyResponse!)
                        self.configureTableHeader(currentData: currentResponse!, weeklyData: weeklyResponse!)
                        return
                    }
                }
                return
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: forecastModel[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func getSavedData() {
        OfflineData.shared.getCurrentWeather { currentResponse in
            OfflineData.shared.getWeeklyWeather { weeklyResponse in
                self.configureTableHeader(currentData: currentResponse, weeklyData: weeklyResponse)
            }
        }
    }
    
    
    func configureTableHeader(currentData: WeatherModel, weeklyData: ForecastResponse){
        self.tableView.tableHeaderView = Utilities().createTableHeader(result: currentData, completion: { color in
            let name = currentData.name
            self.cityName = "\(name)"
            self.view.backgroundColor = color
        })
        
        let utcDifference = TimeZone.current.secondsFromGMT() / 3600
        let noonComponents = DateComponents(hour: 12 + utcDifference, minute: 0, second: 0)
        let dailyWeather = weeklyData.list.filter {
            let dateNew = Date(timeIntervalSince1970: TimeInterval($0.dt))
            return Calendar.current.date(dateNew, matchesComponents:noonComponents)
        }
        
        self.forecastModel.append(contentsOf: dailyWeather)
        DispatchQueue.main.async {
            ERProgressHud.sharedInstance.hide()
            self.tableView.reloadData()
            self.actionButton.isHidden = false
        }
        
        
    }
    
    
}

