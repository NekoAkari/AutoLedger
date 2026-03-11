//
//  TransactionListView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
	
	@Query(sort: \Transaction.date, order: .reverse)
	private var transactions: [Transaction]
	
	@Environment(\.modelContext) private var modelContext
	
	var body: some View {
		NavigationStack {
			Group {
				if transactions.isEmpty {
					ContentUnavailableView("No Transactions Yet", systemImage: "tray", description: Text("Add your first transaction from the Add tab."))
				} else {
					List {
						ForEach(transactions) { transaction in
							HStack(alignment: .top, spacing: 12) {
								VStack(alignment: .leading, spacing: 4) {
									Text(transaction.category)
										.font(.headline)
									
									Text(transaction.note ?? "No note")
										.font(.subheadline)
										.foregroundColor(.secondary)
									
									Text(transaction.date, format: .dateTime.year().month().day().hour().minute())
										.font(.caption)
										.foregroundColor(.gray)
								}
								Spacer()
								VStack(alignment: .trailing, spacing: 4) {
									Text(transaction.type == .expense ? "Expense" : "Income")
										.font(.caption)
										.foregroundStyle(.secondary)
									Text(transaction.amount, format: .currency(code: "CAD"))
										.font(.headline)
										.foregroundColor(transaction.displayColor)
								}
							}
							.padding(.vertical, 4)
						}
						.onDelete(perform: deleteTransations)
					}
				}
			}
			.navigationTitle("Transactions")
		}
	}
	
	private func deleteTransations(at offset:IndexSet) {
		for index in offset {
			modelContext.delete(transactions[index])
		}
	}
}

#Preview {
    TransactionListView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
