//
//  TransactionRow.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-13.
//

import SwiftUI

// MARK: - Transaction Row
struct TransactionRow: View {
	let transaction: Transaction
	
	var body: some View {
		HStack(alignment: .center, spacing: 12) {
			Image(systemName: transaction.type == .expense ? "arrowshape.up.fill" : "arrowshape.down.fill")
				.font(.title3)
				.foregroundStyle(transaction.displayColor)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(transaction.name)
					.font(.headline)
				
				Text(transaction.category)
					.font(.subheadline)
					.foregroundStyle(.secondary)
				
				Text(transaction.date, format: .dateTime.month().day().hour().minute())
					.font(.caption)
					.foregroundStyle(.gray)
			}
			
			Spacer()
			
			VStack(alignment: .trailing, spacing: 4) {
				Text(transaction.displayTypeLabel)
					.font(.caption)
					.foregroundStyle(.secondary)
				
				Text(transaction.amount, format: .currency(code: CurrencySettings.currencyCode))
					.font(.caption)
					.foregroundStyle(transaction.displayColor)
			}
		}
		.padding(.vertical, 4)
	}
}
