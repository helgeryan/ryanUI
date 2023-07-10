//
//  HomeViewModel.swift
//  TestUIApp
//
//  Created by Ryan Helgeson on 7/8/23.
//

import Foundation

struct HomeActionItem {
    let image: String
    let title: String
    let action: HomeAction
}

enum HomeAction {
    case spinnerButton
}


class HomeViewModel {
    let actions = [
        HomeActionItem(image: "circle.hexagonpath.fill", title: "Spinner Button", action: .spinnerButton)
    ]
}
