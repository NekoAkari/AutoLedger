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
    let systemImage: String
	
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Spacer()

                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(color)
                    .symbolRenderingMode(.hierarchical)
            }

			Text(amount, format: .currency(code: CurrencySettings.currencyCode))
                .font(.system(size: 32, weight: .semibold, design: .rounded))
				.foregroundStyle(color)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)
        }
	}
}
