//
//  UIColor + Extensions.swift
//  Cards
//
//  Created by Hugo Prinsloo on 2018/05/17.
//  Copyright © 2018 Hugo. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorTwo.cgColor, colorOne.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIViewController {
    func setBackgroundColor() {
        let color1: UIColor = UIColor(named: "BackgroundC1") ?? .white
        let color2: UIColor = UIColor(named: "BackgroundC2") ?? .white
        view.setGradientBackground(colorOne: color1, colorTwo: color2)
    }
}

extension UIView {
    func addGradientToView(view: UIView)
    {
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors = [UIColor.red.cgColor,    UIColor.green.cgColor, UIColor.blue.cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.6, 0.8]
        
        //define frame
        gradientLayer.frame = view.bounds
        
        //insert the gradient layer to the view layer
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCardColor() {
        let color1: UIColor = UIColor(named: "CardC1") ?? .white
        let color2: UIColor = UIColor(named: "CardC2") ?? .white
        setGradientBackground(colorOne: color1, colorTwo: color2)
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

extension UIImage {
    func asString() -> String? {
        if let imageData = UIImagePNGRepresentation(self) {
            return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        }
        return nil
    }
    
    class func asImage(from string: String) -> UIImage? {
        if let imageData = Data(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

@IBDesignable class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

