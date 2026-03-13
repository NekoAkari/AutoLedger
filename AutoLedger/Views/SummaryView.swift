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
	
		// MARK: - Computed Totals
	private var totalIncome: Double {
		transactions
			.filter { $0.type == .income }
			.reduce(0) { $0 + $1.amount }
	}
	
	private var totalExpense: Double {
		transactions
			.filter { $0.type == .expense }
			.reduce(0) { $0 + $1.amount }
	}
	
	private var balance: Double {
		totalIncome - totalExpense
	}
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				
				SummaryCard(title: "Balance", amount: balance, color: .primary)
				
				SummaryCard(title: "Income", amount: totalIncome, color: .green)
				
				SummaryCard(title: "Expense", amount: totalExpense, color: .red)
				
				Spacer()
			}
			.padding()
			.navigationTitle("Summary")
		}
	}
}

#Preview {
    SummaryView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
