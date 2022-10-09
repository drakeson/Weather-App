//
//  Constants.swift
//  Weather App
//
//  Created by Kato Drake Smith on 04/10/2022.
//

import Foundation
import CoreData
import UIKit

//MARK: - OpenWeatherAPI

let apiKey = "4a605e032f8621d60541439ee2237631"
let scheme = "https"
let host = "api.openweathermap.org"
let path = "/data/2.5"
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
let session = URLSession(configuration: .default)

enum WeatherInfoType {
    static let currentWeather = "weather"
    static let forecast = "forecast"
}




//MARK: - MESSAGES
struct AppMessages {
    static let success = "Successful"
    static let error = "Error fetching data from api"
    static let load = "Loading..."
    static let tryA = "Try Again"
    static let wifi = "Wifi Connection"
    static let mobile = "Cellular Connection"
    static let unavailable = "Internet Not Avialable"
    static let noConnection = "No Connection"
    static let noData = "No data returnned from server"
    static let failed = "Failure response"
    static let invalidResponse = "Unable to process response"
    static let failedRequest = "Failed request from server"
}

//MARK: - ServerMessages
struct ServerMessages {
    static let m404 = "No Items Found"
    static let m500 = "Server Error"
    static let m402 = "Request Failed Try Again"
    static let mRest = "Try Again Later"
}

enum WeatherFetchingError: Error {
    case failedRequest
    case invalidResponse
    case noData
    case invalidData
}



//MARK: - UserDefaults

let defaults = UserDefaults.standard

struct DefaultsKeys {
    static let currentWeather = "currentWeather"
    static let weeklyWeather = "weeklyWeather"
}
