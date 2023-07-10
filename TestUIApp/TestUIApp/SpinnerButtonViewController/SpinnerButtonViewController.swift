//
//  SpinnerButtonViewController.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/8/23.
//

import UIKit
import RyanUI

extension UIView {
    func fixInView(_ view: UIView) {
        view.addSubview(self)
        self.frame = view.bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
    }
}

class SpinnerButtonViewController: UIViewController {
    
    @IBOutlet weak var buttonContainerView: UIView!
    let button: SpinnerButton = SpinnerButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSpinnerButton()
    }
    
    func setupSpinnerButton() {
        button.delegate = self
        button.fixInView(buttonContainerView)
        button.setTintColor(.blue)
        button.setTitle("Submit")
        button.setBackgroundColor(.black)
    }
}

extension SpinnerButtonViewController: SpinnerButtonDelegate {
    func spinnerButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.button.setState(.complete)
        })
    }
}
