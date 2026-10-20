//
//  Settings.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-12.
//

import Foundation
import SwiftUI

/// The shared currency code and symbol used throughout the app.
enum CurrencySettings {
    // MARK: - Currency Configuration

    /// Transactions currently use CAD; per-transaction currencies are not stored.
    static let currencyCode = "CAD"

    /// Reuse one formatter so view redraws do not keep allocating it.
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        return formatter
    }()

    /// The currency symbol resolved by the shared formatter.
    static let currencySymbol: String = formatter.currencySymbol
}
