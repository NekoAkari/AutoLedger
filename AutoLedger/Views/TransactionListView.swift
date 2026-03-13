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
						systemImage: "plus.capsule",
						description: Text("Add your first transaction from the Add tab.")
					)
				} else {
					List {
						ForEach(transactions) { transaction in
							TransactionRow(transaction: transaction)
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
