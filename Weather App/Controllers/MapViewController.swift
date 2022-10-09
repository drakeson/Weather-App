//
//  MapViewController.swift
//  Weather App
//
//  Created by Kato Drake Smith on 09/10/2022.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //MARK: - Propeties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citiesCollectionView: UICollectionView!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    private var models = [Cities]()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getSavedCities()
    }
    
    func getSavedCities() {
        OfflineData.shared.getAllCities { data in
            DispatchQueue.main.async {
                self.models = data
                self.citiesCollectionView.reloadData()
            }
        }
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = "City Map"
        let nib = UINib(nibName: "CityCollectionViewCell", bundle: nil)
        citiesCollectionView.register(nib, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)

        citiesCollectionView.backgroundColor = .clear
        citiesCollectionView.delegate = self
        citiesCollectionView.dataSource = self
        self.view.addSubview(citiesCollectionView)
        self.mapView.showsUserLocation = true
        card.layer.cornerRadius = 7
        card.isHidden = true
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        DispatchQueue.main.async {
            cell.cityImage.image = IPImage(text: model.name!, radius: 25, font: nil, textColor: nil, randomBackgroundColor: true).generateImage()
            cell.cityName.text = model.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        getWeather(city: model.name!)
    }
    
    
    func getWeather(city: String){
        ERProgressHud.sharedInstance.show(withTitle: AppMessages.load)
        NetworkService.shared.fetchPlaceWeatherData(for: city) { response, Error in
            ERProgressHud.sharedInstance.hide()
            guard let name = response?.name else {return}
            guard let temp = response?.main.temp else {return}
            guard let weather = response?.weather[0].main else {return}
            
            self.locationLabel.text = name
            self.weatherLabel.text = weather
            self.tempLabel.text = "\(temp)°"
            self.card.isHidden = false
            
            let latitude = Double((response?.coord.lat)!)
            let longitude = Double((response?.coord.lon)!)
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = name
                annotation.subtitle = weather
            self.mapView.addAnnotation(annotation)
            
            self.locationLabel.textColor = .white
            self.weatherLabel.textColor = .white
            self.tempLabel.textColor = .white
            
            let weatherType = weather.lowercased()
            if weatherType.contains("rain") {
                self.weatherImage.image = UIImage(named: "forest_rainy.png")
                self.card.backgroundColor = UIColor(named: "rainny")
            } else if weatherType.contains("clear") {
                self.locationLabel.textColor = .black
                self.weatherLabel.textColor = .black
                self.tempLabel.textColor = .black
                self.weatherImage.image = UIImage(named: "forest_sunny.png")
                self.card.backgroundColor = UIColor(named: "clear")
            } else {
                self.weatherImage.image = UIImage(named: "forest_cloudy.png")
                self.card.backgroundColor = UIColor(named: "cloudy")
            }

        }
    }
}
