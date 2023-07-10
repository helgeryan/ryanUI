//
//  SpinnerButton.swift
//  
//
//  Created by Ryan Helgeson on 7/8/23.
//

import Foundation
import UIKit

public protocol SpinnerButtonDelegate {
    func spinnerButtonPressed()
}

@IBDesignable
public class SpinnerButton: UIView {
    public var delegate: SpinnerButtonDelegate?
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    public func setTintColor(_ color: UIColor) {
        button.setTitleColor(.orange, for: .normal)
        button.tintColor = color
        imageView.tintColor = color
    }
    
    public func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }
    
    @IBAction func doSpinnerButton(_ sender: Any) {
        delegate?.spinnerButtonPressed()
    }
}

enum SpinnerStates {
    case disabled
    case normal
    case processing
    case complete
}
