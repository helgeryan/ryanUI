//
//  HomeViewModel.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/8/23.
//

import Foundation
import RyanUI

struct HomeActionItem {
    let image: String
    let title: String
    let action: HomeAction
}

enum HomeAction {
    case spinnerButton
    case creditCardScanner
}


class HomeViewModel {
    let actions = [
        HomeActionItem(image: "circle.hexagonpath.fill", title: "Spinner Button", action: .spinnerButton),
        HomeActionItem(image: "creditcard", title: "Credit Card Scanner", action: .creditCardScanner)
    ]
}


extension HomeViewModel: CreditCardScannerDelegate {
    func didReceiveCreditCardInfo(_ creditCard: CreditCard) {
        debugPrint(creditCard)
    }
}
