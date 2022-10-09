//
//  NetworkService.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import Foundation
import CoreLocation

struct NetworkService {
    static let shared = NetworkService()
    
    //MARK: - Fetch Weather Data
    private func fetchWeatherData<T: Codable>(dataType: T.Type,
                                      weatherInfoType: String,
                                              location: CLLocation,
                                      completion: @escaping (T?, WeatherFetchingError?) -> Void) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + "/" + weatherInfoType
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        
        let url = components.url!
        
        let sessionTask = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from server: \(error!), \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("Failure response with code: \(httpResponse.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returnned from server")
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(T.self, from: data)
                    completion(results, nil)
                } catch let error {
                    print("Failed decoding data with error: \(error), \(error.localizedDescription)")
                    completion(nil, .invalidData)
                    return
                }
            }
        }
        sessionTask.resume()
    }
    
    func fetchCurrentWeatherData(for location: CLLocation, completion: @escaping (WeatherModel?, WeatherFetchingError?) -> Void ) {
        fetchWeatherData(dataType: WeatherModel.self, weatherInfoType: WeatherInfoType.currentWeather, location: location, completion: completion)
    }
    
    func fetchForecastWeatherData(for location: CLLocation, completion: @escaping (ForecastResponse?, WeatherFetchingError?) -> Void ) {
        fetchWeatherData(dataType: ForecastResponse.self, weatherInfoType: WeatherInfoType.forecast, location: location, completion: completion)
    }
    
    
    
    
    
    //MARK: - Location Weather Data
    
    private func fetchLocationWeatherData<T: Codable>(dataType: T.Type,
                                      weatherInfoType: String,
                                                      placeName: String,
                                      completion: @escaping (T?, WeatherFetchingError?) -> Void) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + "/" + weatherInfoType
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "q", value: placeName),
            URLQueryItem(name: "units", value: "metric"),
        ]
        
        
        let url = components.url!
        
        let sessionTask = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from server: \(error!), \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("Failure response with code: \(httpResponse.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returnned from server")
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(T.self, from: data)
                    print(results)
                    completion(results, nil)
                } catch let error {
                    print("Failed decoding data with error: \(error), \(error.localizedDescription)")
                    completion(nil, .invalidData)
                    return
                }
            }
        }
        sessionTask.resume()
    }
    
    
    func fetchPlaceWeatherData(for placeName: String, completion: @escaping (WeatherModel?, WeatherFetchingError?) -> Void ) {
        fetchLocationWeatherData(dataType: WeatherModel.self, weatherInfoType: WeatherInfoType.currentWeather, placeName: placeName, completion: completion)
    }
    
    
}
