//
//  File.swift
//  
//
//  Created by Ryan Helgeson on 7/13/23.
//

import Foundation

extension String {
    var isOnlyAlpha: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }

    var isOnlyNumbers: Bool {
        return !isEmpty && range(of: "[^0-9]", options: .regularExpression) == nil
    }

    // Date Pattern MM/YY or MM/YYYY
    var isDate: Bool {
        let arrayDate = components(separatedBy: "/")
        if arrayDate.count == 2 {
            let currentYear = Calendar.current.component(.year, from: Date())
            if let month = Int(arrayDate[0]), let year = Int(arrayDate[1]) {
                if month > 12 || month < 1 {
                    return false
                }
                if year < (currentYear - 2000 + 20) && year >= (currentYear - 2000) { // Between current year and 20 years ahead
                    return true
                }
                if year >= currentYear && year < (currentYear + 20) { // Between current year and 20 years ahead
                    return true
                }
            }
        }
        return false
    }
}
