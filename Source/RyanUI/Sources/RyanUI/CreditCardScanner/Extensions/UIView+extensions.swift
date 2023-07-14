//
//  UIView+extensions.swift
//  
//
//  Created by Ryan Helgeson on 7/14/23.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return .white // TODO: - Not set to just white
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
