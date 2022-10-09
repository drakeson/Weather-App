//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import Foundation

struct ForecastResponse: Codable {
    var list: [WeatherData]
}

struct WeatherData: Codable {
    var dt: Int
    let weather: [DailyWeather]
    let main: MainData
    let wind: Wind
    var dt_txt: String
}

