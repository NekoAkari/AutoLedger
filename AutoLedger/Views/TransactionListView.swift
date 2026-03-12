//
//  TransactionListView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
	// MARK: - Data Query
	// Automatically fetch transactions from SwiftDate, sorted by newest first.
	@Query(sort: \Transaction.date, order: .reverse)
	private var transactions: [Transaction]
	
	// Access to the SwiftData context for deleting records.
	@Environment(\.modelContext) private var modelContext
	
	var body: some View {
		NavigationStack {
			Group {
				if transactions.isEmpty {
					ContentUnavailableView(
						"No Transactions Yet",
						systemImage: "tray",
						description: Text("Add your first transaction from the Add tab.")
					)
				} else {
					List {
						ForEach(transactions) { transaction in
							HStack(alignment: .center, spacing: 12) {
								// MARK: - Transaction Icon
								Image(systemName: transaction.type == .expense ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
									.font(.title3)
									.foregroundStyle(transaction.displayColor)
								// MARK: - Transaction Info (Left Side)
								VStack(alignment: .leading, spacing: 4) {
									
									// Display transaction name as the main title.
									Text(transaction.name)
										.font(.headline)
									
									// Show category under the name
									Text(transaction.category)
										.font(.subheadline)
										.foregroundStyle(.secondary)
									
									// Display formatted date and time.
									Text(transaction.date, format: .dateTime.month().day().hour().minute())
										.font(.caption)
										.foregroundStyle(.gray)
								}
								Spacer()
								
								// MARK: - Amount & Type (Right Side)
								VStack(alignment: .trailing, spacing: 4) {
									Text(transaction.type == .expense ? "Expense" : "Income")
										.font(.caption)
										.foregroundStyle(.secondary)
									Text(transaction.amount, format: .currency(code: CurrencySettings.currencyCode))
										.font(.headline)
										.foregroundStyle(transaction.displayColor)
								}
							}
							.padding(.vertical, 4)
						}
						.onDelete(perform: deleteTransactions)
					}
				}
			}
			.navigationTitle("Transactions")
		}
	}
	
	// MARK: - Delete Action
	// Remove selected transaction from SwiftData.
	private func deleteTransactions(at offset:IndexSet) {
		for index in offset {
			modelContext.delete(transactions[index])
		}
	}
}

#Preview {
    TransactionListView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
