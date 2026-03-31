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

    #if os(macOS)
    @State private var selection: PersistentIdentifier?
    @State private var isEditingSelection = false
    #endif
	
	var body: some View {
        #if os(macOS)
        Group {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions Yet",
                    systemImage: "plus.capsule",
                    description: Text("Add your first transaction from the Add Transaction section.")
                )
            } else {
                Table(transactions, selection: $selection) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Category", value: \.category)
                    TableColumn("Type") { transaction in
                        Text(transaction.type == .expense ? "Expense" : "Income")
                            .foregroundStyle(.secondary)
                    }
                    TableColumn("Date") { transaction in
                        Text(transaction.date, format: .dateTime.year().month(.abbreviated).day().hour().minute())
                    }
                    TableColumn("Amount") { transaction in
                        Text(transaction.amount, format: .currency(code: CurrencySettings.currencyCode))
                            .foregroundStyle(transaction.displayColor)
                    }
                }
            }
        }
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isEditingSelection = true
                } label: {
                    Label("Edit", systemImage: "square.and.pencil")
                }
                .disabled(selectedTransaction == nil)

                Button(role: .destructive) {
                    deleteSelectedTransaction()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selectedTransaction == nil)
            }
        }
        .sheet(isPresented: $isEditingSelection) {
            if let selectedTransaction {
                NavigationStack {
                    TransactionEditorView(transaction: selectedTransaction)
                }
                .frame(minWidth: 520, minHeight: 420)
            }
        }
        #elseif os (iOS)
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
                            NavigationLink {
                                TransactionEditorView(transaction: transaction)
                            } label: {
                                TransactionRow(transaction: transaction)
                            }
                        }
						.onDelete(perform: deleteTransactions)
					}
				}
			}
			.navigationTitle("Transactions")
		}
        #endif
	}
	
	// MARK: - Delete Action
	// Remove selected transaction from SwiftData.
	private func deleteTransactions(at offset:IndexSet) {
		for index in offset {
			modelContext.delete(transactions[index])
		}
	}

    #if os(macOS)
    private var selectedTransaction: Transaction? {
        guard let selection else { return nil }
        return transactions.first { $0.persistentModelID == selection }
    }

    private func deleteSelectedTransaction() {
        guard let selectedTransaction else { return }
        modelContext.delete(selectedTransaction)
        selection = nil
    }
    #endif
}

#Preview {
    TransactionListView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
