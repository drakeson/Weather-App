//
//  OfflineData.swift
//  Weather App
//
//  Created by Kato Drake Smith on 09/10/2022.
//

import UIKit

struct OfflineData {
    static let shared = OfflineData()
    
    
    
    //MARK: - Current Weather Data
    
    func saveCurrentWeather(currentWeather: WeatherModel) {
        if let encoded = try? JSONEncoder().encode(currentWeather) {
            UserDefaults.standard.set(encoded, forKey: DefaultsKeys.currentWeather)
        }
        //defaults.removeObject(forKey: DefaultsKeys.currentWeather)
        //defaults.set(currentWeather, forKey: DefaultsKeys.currentWeather)
    }
    
    func getCurrentWeather(completion: @escaping (_ data: WeatherModel) -> Void) {
        if let data = UserDefaults.standard.object(forKey: DefaultsKeys.currentWeather) as? Data,
           let currentWeather = try? JSONDecoder().decode(WeatherModel.self, from: data) {
            completion(currentWeather)
        }
    }
    
    
    //MARK: - Weekly Weather Data
    func saveWeeklyWeather(weeklyWeather: ForecastResponse) {
        if let encoded = try? JSONEncoder().encode(weeklyWeather) {
            UserDefaults.standard.set(encoded, forKey: DefaultsKeys.weeklyWeather)
        }
    }

    func getWeeklyWeather(completion: @escaping (_ data: ForecastResponse) -> Void) {
        if let data = UserDefaults.standard.object(forKey: DefaultsKeys.weeklyWeather) as? Data,
           let weeklyWeather = try? JSONDecoder().decode(ForecastResponse.self, from: data) {
            completion(weeklyWeather)
        }
    }
    
    
    
    
    
    //MARK: - Cities
    func getAllCities(completion: @escaping (_ data: [Cities]) -> Void) {
        do {
            let data = try context.fetch(Cities.fetchRequest())
            completion(data)
        }
        catch { }
    }
    
    
    func createCity(name: String, completion: @escaping (_ message: String) -> Void) {
        let newItem = Cities(context: context)
        newItem.name = name
        newItem.date = Date()
        
        do {
            try context.save()
            completion("Added to Favourites")
        } catch {}
    }
    
    
    func deleteCity(city: Cities, completion: @escaping (_ message: String) -> Void) {
        context.delete(city)
        do {
            try context.save()
            completion("Deleted")
        } catch {}
    }
    
    
}
