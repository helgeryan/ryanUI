//
//  SpinnerButton.swift
//  
//
//  Created by Ryan Helgeson on 7/8/23.
//

import Foundation
import UIKit

// MARK: - Spinner Button Delegate
public protocol SpinnerButtonDelegate {
    func spinnerButtonPressed()
}

// MARK: - Spinner Button
public class SpinnerButton: UIView {
    // MARK: - Properties
    public var delegate: SpinnerButtonDelegate?
    var buttonBackgroundColor: UIColor = .white
    var buttonTitle: String = ""
    
    // MARK: - UI Elementes
    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        return button
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "checkmark")
        }
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 0
        return imageView
    }()
    
    var spinner: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.isUserInteractionEnabled = false
        return activity
    }()
    
    // MARK: - Constraints
    var leadingConstraint: NSLayoutConstraint?
    var trailingConstraint: NSLayoutConstraint?
    var leadingProcessingConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    // MARK: - Setup Functions
    func setupView() {
        setupButton()
        setupImageView()
        setupActivity()
    }
    
    func setupButton() {
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 0)
        leadingProcessingConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .leading, multiplier: 1, constant: 20)
        leadingProcessingConstraint?.isActive = false
        trailingConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: button, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraints([
            leadingConstraint!,
            trailingConstraint!,
            leadingProcessingConstraint!,
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(doSpinnerButton), for: .touchUpInside)
    }
    
    func setupImageView() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: imageView, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func setupActivity() {
        self.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: spinner, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: spinner, attribute: .centerY, multiplier: 1, constant: 0),
            spinner.heightAnchor.constraint(equalToConstant: 20),
            spinner.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Public Setter Functions
    public func setBackgroundColor(_ color: UIColor) {
        buttonBackgroundColor = color
        button.backgroundColor = color
    }

    public func setTintColor(_ color: UIColor) {
        spinner.tintColor = color
        imageView.tintColor = color
        button.tintColor = color
        button.setTitleColor(color, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    public func setTitle(_ title: String) {
        buttonTitle = title
        button.setTitle(title, for: .normal)
    }
    
    public func setState(_ state: SpinnerState) {
        switch state {
        case .disabled:
            button.isEnabled = false
            break
        case .normal:
            bindNormalState()
            break
        case .processing:
            bindProcessingState()
            break
        case .complete:
            bindCompleteState()
            break
        }
    }
    
    // MARK: - Action Functions
    @objc func doSpinnerButton(_ sender: Any) {
        print("Button pressed")
        delegate?.spinnerButtonPressed()
        setState(.processing)
    }
    
    // MARK: - Binding Functions
    func bindNormalState() {
        button.isEnabled = true
        button.setTitle(buttonTitle, for: .normal)
        leadingConstraint?.isActive = true
        leadingProcessingConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.imageView.alpha = 0
            self.button.backgroundColor = self.buttonBackgroundColor
            self.layoutIfNeeded()
        })
        
        spinner.stopAnimating()
    }
    
    func bindProcessingState() {
        button.isEnabled = false
        button.setTitle("", for: .normal)
        leadingConstraint?.isActive = false
        leadingProcessingConstraint?.constant = self.bounds.height / 2.0
        leadingProcessingConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.button.backgroundColor = .clear
            self.layoutIfNeeded()
        })
        spinner.startAnimating()
    }
    
    func bindCompleteState() {
        spinner.stopAnimating()
        button.isEnabled = false
        button.setTitle("", for: .normal)
        leadingConstraint?.isActive = false
        leadingProcessingConstraint?.constant = self.bounds.height / 2.0
        leadingProcessingConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.button.backgroundColor = .clear
            self.imageView.alpha = 1
            self.layoutIfNeeded()
        })
        
        // After one second set back to the normal state
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.setState(.normal)
        })
    }
}

// MARK: - Spinner States
public enum SpinnerState {
    case disabled
    case normal
    case processing
    case complete
}
