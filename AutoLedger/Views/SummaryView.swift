//
//  SummaryView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftData
import SwiftUI

/// Displays balance, income, and expense totals from the stored transactions.
struct SummaryView: View {
    // MARK: - Fetch Transactions

    @Query private var transactions: [Transaction]

    /// Aggregates income and expense in one pass using each stored transaction type.
    private var totals: TransactionTotals {
        transactions.reduce(into: TransactionTotals()) { totals, transaction in
            switch transaction.type {
            case .income:
                totals.income += transaction.amount
            case .expense:
                totals.expense += transaction.amount
            }
        }
    }

    // MARK: - Summary Layout

    var body: some View {
        // Calculate one snapshot for all three cards in this body evaluation.
        let totals = totals

        #if os(macOS)
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SummaryCard(title: "Balance", amount: totals.balance, color: .primary)
                SummaryCard(title: "Income", amount: totals.income, color: .green)
                SummaryCard(title: "Expense", amount: totals.expense, color: .red)
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(24)
        }
        .navigationTitle("Summary")
        #elseif os(iOS)
        VStack(spacing: 24) {
            SummaryCard(title: "Balance", amount: totals.balance, color: .primary)
            SummaryCard(title: "Income", amount: totals.income, color: .green)
            SummaryCard(title: "Expense", amount: totals.expense, color: .red)

            Spacer()
        }
        .padding()
        .navigationTitle("Summary")
        #endif
    }
}

/// The aggregate amounts used by the summary cards.
private struct TransactionTotals {
    var income: Double = 0
    var expense: Double = 0

    /// The net balance after subtracting expenses from income.
    var balance: Double {
        income - expense
    }
}

#Preview {
    SummaryView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
