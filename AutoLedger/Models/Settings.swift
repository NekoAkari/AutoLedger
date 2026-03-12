//
//  Settings.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-12.
//

import Foundation
import SwiftUI

struct CurrencySettings {
	static let currencyCode = "CAD"
	
	static var currencySymbol: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = CurrencySettings.currencyCode
		return formatter.currencySymbol
	}
}


