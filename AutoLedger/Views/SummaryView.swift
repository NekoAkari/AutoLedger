//
//  SummaryView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    // MARK: - Fetch Transactions
    @Query private var transactions: [Transaction]

    // Aggregate income and expense in one pass to reduce work during updates.
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

    var body: some View {
        let totals = totals

        NavigationStack {
            VStack(spacing: 24) {
                SummaryCard(title: "Balance", amount: totals.balance, color: .primary)
                SummaryCard(title: "Income", amount: totals.income, color: .green)
                SummaryCard(title: "Expense", amount: totals.expense, color: .red)

                Spacer()
            }
            .padding()
            .navigationTitle("Summary")
        }
    }
}

private struct TransactionTotals {
    var income: Double = 0
    var expense: Double = 0

    var balance: Double {
        income - expense
    }
}

#Preview {
    SummaryView()
        .modelContainer(for: Transaction.self, inMemory: true)
}
