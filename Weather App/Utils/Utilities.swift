//
//  Utilities.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import UIKit

class Utilities {
    
    func createTableHeader(result: WeatherModel, completion: @escaping(UIColor) -> Void) -> UIView {
        let name = "\(result.name)"
        let weather = result.weather[0].main.lowercased()
        let temperature = "\(result.main.temp)°"
//        let humidity = "\(result.main.humidity)"
//        let speed = "\(result.wind.speed)"
//        let date = "\(Date(timeIntervalSince1970: TimeInterval(result.dt)))"
        
        
        let headerView = UIView()
        let screenWidth = UIScreen.main.bounds.size.width
        //let screenHeight = UIScreen.main.bounds.size.height
        
        headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 320)

        let locationLabel = UILabel()
        locationLabel.frame = CGRect(x: 10, y: 10,
                                     width: screenWidth - 30,
                                     height: headerView.frame.size.height/5)
        
        let tempLabel = UILabel()
        tempLabel.frame = CGRect(x: 10, y: locationLabel.frame.size.height + 10,
                                 width: screenWidth - 30,
                                 height: headerView.frame.size.height/5)
        
        let summaryLabel = UILabel()
        summaryLabel.frame = CGRect(x: 10, y: tempLabel.frame.size.height + 10,
                                    width: screenWidth - 30,
                                    height: headerView.frame.size.height/2)
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        
        locationLabel.text = name
        locationLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)

        tempLabel.text = temperature
        tempLabel.font = UIFont.systemFont(ofSize: 45, weight: .light)
        
        summaryLabel.text = weather
        summaryLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        
        if weather.contains("rain") {
            headerView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_rainy.png")!)
            completion(UIColor(named: "rainny")!)
        } else if weather.contains("clear") {
            headerView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_sunny.png")!)
            completion(UIColor(named: "clear")!)
        } else {
            headerView.backgroundColor = UIColor(patternImage: UIImage(named: "forest_cloudy.png")!)
            completion(UIColor(named: "cloudy")!)
        }
        return headerView
    }
    
    //MARK: - Text Field
    func textLabel(with placeholder: String, fontSize: CGFloat) -> UILabel {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: fontSize)
        return textLabel
    }
    
    
    
}
