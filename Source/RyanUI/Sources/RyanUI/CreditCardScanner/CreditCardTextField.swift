//
//  CreditCardTextField.swift
//  
//
//  Created by Ryan Helgeson on 7/15/23.
//

import UIKit

@IBDesignable
public class CreditCardTextField: UITextField {
    public var isCreditCardInfo: Bool = true
    public var creditCardDelegate: CreditCardScannerDelegate?
    
    @IBInspectable var isCreditCardTextField: Bool {
        get {
            return self.isCreditCardInfo
        }
        set {
            self.isCreditCardInfo = newValue
        }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        addLeftView()
        addCreditCardToolBar()
    }
    
    func addLeftView() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        self.leftViewMode = .always
    }
    
    func addCreditCardToolBar() {
        let bar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIButton()
        button.setTitle("Scan Card", for: .normal)
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "creditcard"), for: .normal)
        }
        button.tintColor = .systemBlue
        button.setTitleColor(.systemBlue, for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 2
            button.configuration = config
        } else {
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        button.addTarget(self, action: #selector(doScanCard), for: .touchUpInside)
        let creditCardButton = UIBarButtonItem(customView: button)
        
        bar.items = [flexSpace, creditCardButton, flexSpace]
        bar.sizeToFit()
        self.inputAccessoryView = bar
    }
    
    @objc func doScanCard() {
        if let creditCardDelegate = creditCardDelegate {
            self.resignFirstResponder()
            let scanner = CreditCardScanner(delegate: creditCardDelegate)
            creditCardDelegate.showScanner(scanner)
        }
    }
    
    public func setDelegate(_ delegate: CreditCardScannerDelegate & UITextFieldDelegate) {
        self.creditCardDelegate = delegate
        self.delegate = delegate
    }
}
