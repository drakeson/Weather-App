//
//  CityCollectionViewCell.swift
//  Weather App
//
//  Created by Kato Drake Smith on 09/10/2022.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    
    override func prepareForReuse() {
        self.cityImage.image = #imageLiteral(resourceName: "like_filled")
        self.cityName.text = "City"
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async {
            self.backgroundColor = .white
            self.layer.cornerRadius = 5
            self.cityName.textAlignment = .center
            self.cityName.lineBreakMode = NSLineBreakMode.byWordWrapping
            self.cityName.numberOfLines = 0
            self.cityImage.clipsToBounds = true
        }
    }
    
    static let identifier = "cityCell"
    static func nib() -> UINib{
        return UINib(nibName: "cityCell", bundle: nil)
    }

}
