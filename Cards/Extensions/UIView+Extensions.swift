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
    func setBackgroundColor() {
        let color1: UIColor = UIColor(named: "BackgroundC1") ?? .white
        let color2: UIColor = UIColor(named: "BackgroundC2") ?? .white
        setGradientBackground(colorOne: color1, colorTwo: color2)
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


public extension NSLayoutConstraint {
    
    /// Sets up all edges of one view to fill another with insets.
    /// Uses top, bottom, left and right.
    ///
    /// - parameter view: View that should be constrainted
    /// - parameter containerView: View that constrained view should fill
    /// - parameter insets: Possible insets for the view, defaults to zero
    /// - returns: Array of NSLayoutConstraints to satisfy fill
    @objc(ov_constraintsForView:toFillView:insets:)
    class func constraints(for view: UIView, toFill containerView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        let top = view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: insets.top)
        let bottom = view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -insets.bottom)
        let left = view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: insets.left)
        let right = view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -insets.right)
        return [top, bottom, left, right]
    }
    
    /// Sets up all edges of one view to fill a layout guide.
    /// Uses top, bottom, left and right.
    ///
    /// - parameter view: View that should be constrainted
    /// - parameter layoutGuide: Layout guide that constrained view should fill
    /// - parameter insets: Possible insets for the view, defaults to zero
    /// - returns: Array of NSLayoutConstraints to satisfy fill
    @objc(ov_constraintsForView:toFillLayoutGuide:insets:)
    class func constraints(for view: UIView, toFill layoutGuide: UILayoutGuide, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        let top = view.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top)
        let bottom = view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom)
        let left = view.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left)
        let right = view.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right)
        return [top, bottom, left, right]
    }
}

public extension UIView {
    
    /// Creates and activates constraints for the view to fill its superview
    /// with a given set of edge insets
    @objc func fillSuperview(insets: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let superview = superview else {
            assert(false, "make sure to set superview")
            return
        }
        
        let constraints = NSLayoutConstraint.constraints(for: self, toFill: superview, insets: insets)
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Creates and activates constraints for the view to fill its superview
    /// with a given set of edge insets
    @available(iOS 11.0, *)
    func fillSafeAreasInSuperview(insets: UIEdgeInsets = UIEdgeInsets.zero) {
        guard let superview = superview else {
            assert(false, "make sure to set superview")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = NSLayoutConstraint.constraints(for: self, toFill: superview.safeAreaLayoutGuide, insets: insets)
        NSLayoutConstraint.activate(constraints)
    }
    
    /// Creates and activates constraints for the view to center in its superview
    func centerToSuperview() {
        guard let superview = superview else {
            assert(false, "make sure to set superview")
            return
        }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
}

extension String {
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, count)]))
        }
        return result
    }
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
}
