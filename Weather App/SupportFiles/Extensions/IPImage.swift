//
//  IPImage.swift
//  Game of Thrones Houses
//
//  Created by Kato Drake Smith on 25/08/2022.
//

import UIKit

public class IPImage: NSObject {
    
    //MARK: - Properties
    
    public var text:String = ""
    
    private var _radius:Double = 0
    private var _length:Double = 0
    
    public var radius:Double {
        get {
            return _radius
        }
        set {
            _radius = newValue
            _length = _radius * 2
        }
    }
    
    public var font:UIFont?
    
    public var textColor:UIColor?

    public var backgroundColor:UIColor?
    
    //MARK: - Initailization
    public convenience override init() {
        self.init(text: "", radius: 25)
    }
    public convenience init(text: String, radius: Double) {
        self.init(text: text, radius: radius, font: nil)
    }
    
    public convenience init(text: String, radius: Double, font: UIFont?) {
        self.init(text: text, radius: radius, font: font, textColor: nil, randomBackgroundColor: false)
    }
    
    public init(text: String, radius: Double, font: UIFont?, textColor: UIColor?, randomBackgroundColor: Bool) {
        super.init()
        
        self.text = text
        self.radius = radius
        self.textColor = textColor ?? .white
        self.backgroundColor = randomBackgroundColor ? self.randomColor() : .gray
        
        if let aFont = font {
            if aFont.pointSize > CGFloat(radius) {
                self.font = UIFont(name: aFont.fontName, size: CGFloat(radius))
            } else {
                self.font = font
            }
        } else {
            self.font = UIFont.systemFont(ofSize: CGFloat(radius))
        }
        
    }
    public init(text: String, radius: Double, font: UIFont?, textColor: UIColor?, backgroundColor: UIColor?) {
        super.init()
        
        self.text = text
        self.radius = radius
        self.textColor = textColor ?? .white
        self.backgroundColor = backgroundColor ?? .lightGray
        
        if let aFont = font {
            if aFont.pointSize > CGFloat(radius) {
                self.font = UIFont(name: aFont.fontName, size: CGFloat(radius))
            } else {
                self.font = font
            }
        } else {
            self.font = UIFont.systemFont(ofSize: CGFloat(radius))
        }
        
    }
    
    //MARK: - Private
    private func randomColor() -> UIColor {
        
        let red = CGFloat(arc4random_uniform(256))/255.0
        let green = CGFloat(arc4random_uniform(256))/255.0
        let blue = CGFloat(arc4random_uniform(256))/255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
    private func setupView() -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: _length, height: _length))
        view.backgroundColor = backgroundColor
        view.addSubview(setupLabel())
        rounded(view: view)
        
        return view
    }
    
    private func setupLabel() -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: _length, height: _length))
        label.text = initials()
        label.font = font
        label.textColor = textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.allowsDefaultTighteningForTruncation = true
        return label
        
    }
    
    private func rounded(view: UIView) {
        
        let width = view.frame.width
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(ovalIn: CGRect(x: view.bounds.midX - width / 2, y: view.bounds.midY - width / 2, width: width, height: width)).cgPath
        view.layer.mask = mask
    }
    
    //MARK: - Text Generation
    public func initials() -> String {
        
        let names = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
            
        if names.count > 1 {
            
            let firstName = names[0]
            let lastName = names[names.count - 1]
            
            let firstNameInitial = firstName.substring(to: firstName.index(after: firstName.startIndex)).uppercased()
            let lastNameInitial = lastName.substring(to: lastName.index(after: lastName.startIndex)).uppercased()
            
            return (firstNameInitial + lastNameInitial)
            
        } else {
            
            if text == "" {
                return ""
            }
            
            let firstName = text
            let firstNameInitial = firstName.substring(to: firstName.index(after: firstName.startIndex)).uppercased()
            return firstNameInitial
        }
        
    }
    
    //MARK: - Image Generation
    public func generateImage() -> UIImage? {
        
        let view = setupView()
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
