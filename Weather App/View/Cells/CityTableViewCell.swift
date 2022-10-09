//
//  CityTableViewCell.swift
//  Weather App
//
//  Created by Kato Drake Smith on 09/10/2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    let cityImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "like_filled"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
     }()
    
    let cityName : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
     }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "cell"
    static func nib() -> UINib{
        return UINib(nibName: "cell", bundle: nil)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cityImage)
        contentView.addSubview(cityName)
        
        cityImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor,
                         paddingTop: 5, paddingLeft: 5, paddingBottom: 5,
                         width: 50, height: 50
        )
        
        cityName.anchor(top: topAnchor, left: cityImage.rightAnchor,
                        paddingTop: 12, paddingLeft: 10
                        
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
