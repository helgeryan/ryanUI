//
//  CreditCardViewController.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/15/23.
//

import UIKit
import RyanUI

class CreditCardViewController: UIViewController {

    @IBOutlet weak var dateTextField: CreditCardTextField!
    @IBOutlet weak var cvvTextField: CreditCardTextField!
    @IBOutlet weak var numbertextField: CreditCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateTextField.setDelegate(self)
        numbertextField.setDelegate(self)
        cvvTextField.setDelegate(self)
        
    }

}



extension CreditCardViewController: CreditCardScannerDelegate {
    func didReceiveCreditCardInfo(_ creditCard: CreditCard) {
        numbertextField.text = creditCard.number
        cvvTextField.text = creditCard.cvv
        dateTextField.text = creditCard.date
        debugPrint(creditCard)
    }
    
    func showScanner(_ scanner: CreditCardScanner) {
        present(scanner, animated: true)
    }
}

extension CreditCardViewController: UITextFieldDelegate {
    
}
