//
//  Settings.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-12.
//

import Foundation

struct CurrencySettings {
    static let currencyCode = "CAD"

    // Reuse one formatter so view redraws do not keep allocating it.
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter
    }()

    static let currencySymbol: String = formatter.currencySymbol
}
