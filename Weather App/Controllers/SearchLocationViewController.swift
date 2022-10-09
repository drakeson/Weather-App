//
//  SearchLocationViewController.swift
//  Weather App
//
//  Created by Kato Drake Smith on 07/10/2022.
//

import UIKit
import CoreData

class SearchLocationViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: - Propeties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    var forecastModel = [WeatherData]()
    private var models = [Cities]()
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
        getSavedData()
    }


    //MARK: - Selectors
    @objc func fabTapped() {
        OfflineData.shared.createCity(name: cityName) { message in
            self.view.makeToast(message, duration: 3.0, position: .bottom)
        }
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = "Search Location"
        searchBar.delegate = self
        view.backgroundColor = UIColor(named: "clear")
        view.addSubview(actionButton)
        actionButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
            paddingBottom: 64, paddingRight: 16,
            width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        actionButton.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let place = searchBar.text {
            ERProgressHud.sharedInstance.show(withTitle: AppMessages.load)
            NetworkService.shared.fetchPlaceWeatherData(for: place) { response, error in
                ERProgressHud.sharedInstance.hide()
                if error != nil {
                    self.view.makeToast("City Not Found", duration: 3.0, position: .bottom)
                    return
                }
                self.uiData(response: response!)
            }
        }
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func uiData(response: WeatherModel){
        actionButton.isHidden = false
        cityName = response.name
        locationLabel.text = cityName
        weatherLabel.text = "\(response.weather[0].main)"
        tempLabel.text = "\(response.main.temp)°"
        humidityLabel.text = "Humidity: \(response.main.humidity)"
        pressureLabel.text = "Pressure: \(response.main.pressure)"
        windSpeedLabel.text = "Wind Speed: \(response.wind.speed)"
        
        locationLabel.textColor = .white
        weatherLabel.textColor = .white
        tempLabel.textColor = .white
        humidityLabel.textColor = .white
        pressureLabel.textColor = .white
        windSpeedLabel.textColor = .white
        
        let weatherType = response.weather[0].main.lowercased()
        if weatherType.contains("rain") {
            self.card.backgroundColor = UIColor(patternImage: UIImage(named: "forest_rainy.png")!)
            self.view.backgroundColor = UIColor(named: "rainny")
        } else if weatherType.contains("clear") {
            locationLabel.textColor = .black
            weatherLabel.textColor = .black
            tempLabel.textColor = .black
            humidityLabel.textColor = .black
            pressureLabel.textColor = .black
            windSpeedLabel.textColor = .black
            self.card.backgroundColor = UIColor(patternImage: UIImage(named: "forest_sunny.png")!)
            self.view.backgroundColor = UIColor(named: "clear")
        } else {
            self.card.backgroundColor = UIColor(patternImage: UIImage(named: "forest_cloudy.png")!)
            self.view.backgroundColor = UIColor(named: "cloudy")
        }
    }
    
    func getSavedData() {
        OfflineData.shared.getCurrentWeather { [self] data in
            uiData(response: data)
        }
    }
    
    
}
