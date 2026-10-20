//
//  TransactionRow.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-13.
//

import SwiftUI

// MARK: - Transaction Row

/// A compact transaction description and amount for the iOS transaction list.
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Derive the direction icon and color from the stored type.
            Image(systemName: transaction.type == .expense ? "arrowshape.up.fill" : "arrowshape.down.fill")
                .font(.title3)
                .foregroundStyle(transaction.displayColor)

            // Transaction Details (Left)
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

            // Amount & Type (Right)
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.type == .expense ? "Expense" : "Income")
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
