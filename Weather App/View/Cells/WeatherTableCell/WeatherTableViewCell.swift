//
//  WeatherTableViewCell.swift
//  Weather App
//
//  Created by Kato Drake Smith on 05/10/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTemp: UILabel!
    @IBOutlet var lowTemp: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = .clear
        // Configure the view for the selected state
    }
    
    static let identifier = "WeatherTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: WeatherData) {
        self.lowTemp.text = "L: \(Int(model.main.temp_min))°"
        self.highTemp.text = "H: \(Int(model.main.temp_max))°"
        
        
        
        let dayLabelString = Date(timeIntervalSince1970: Double(model.dt)).getDayForDate()

        self.dayLabel.text = dayLabelString
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        let weather = model.weather[0].main
        
        if weather.lowercased().contains("rain") {
            self.iconImageView.image = UIImage(named: "rainny")
        } else if weather.lowercased().contains("clear") {
            self.iconImageView.image = UIImage(named: "clear")
        } else {
            self.iconImageView.image = UIImage(named: "cloudy")
        }
    }
    
}
