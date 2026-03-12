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
				
				summaryCard(title: "Balance", amount: balance, color: .primary)
				
				summaryCard(title: "Income", amount: totalIncome, color: .green)
				
				summaryCard(title: "Expense", amount: totalExpense, color: .red)
				
				Spacer()
			}
			.padding()
			.navigationTitle("Summary")
		}
    }
	
	// MARK: - Summary Card
	@ViewBuilder
	private func summaryCard(title: String, amount: Double, color:Color) -> some View {
		VStack(alignment: .leading, spacing: 8) {
			
			Text(title)
				.font(.headline)
				.foregroundStyle(.secondary)
			
			Text(amount, format: .currency(code: "CAD"))
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

#Preview {
    SummaryView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
