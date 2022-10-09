//
//  WeatherModel.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import Foundation


struct WeatherModel: Codable {
    let coord: Coordinates
    let weather: [DailyWeather]
    let main: MainData
    let wind: Wind
    let dt: Int
    let name: String
    let sys: System
}

struct Coordinates: Codable {
    let lon: Float
    let lat: Float
}

struct DailyWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct MainData: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Float
}

struct System: Codable {
    let country: String
}
