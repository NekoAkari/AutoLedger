//
//  SummaryCard.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-13.
//

import SwiftUI

// MARK: - Summary Card
struct SummaryCard: View {
	let title: String
	let amount: Double
	let color: Color
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			
			Text(title)
				.font(.headline)
				.foregroundStyle(.secondary)
			
			Text(amount, format: .currency(code: CurrencySettings.currencyCode))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundStyle(color)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
		.background(.ultraThinMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}
}
