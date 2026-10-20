//
//  TransactionListView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftData
import SwiftUI

/// Displays transaction history with editing and deletion controls for each platform.
struct TransactionListView: View {
    // MARK: - Data Query

    /// Fetches transactions from SwiftData, sorted by newest date first.
    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]

    /// Access to the SwiftData context for deleting records.
    @Environment(\.modelContext) private var modelContext

    #if os(macOS)
    // Table selection uses the model identifier to locate the record for edit or delete.
    @State private var selection: PersistentIdentifier?
    @State private var isEditingSelection = false
    #endif

    // MARK: - List Layout

    var body: some View {
        #if os(macOS)
        Group {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions Yet",
                    systemImage: "plus.capsule",
                    description: Text("Add your first transaction using the Add button.")
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
        #elseif os(iOS)
        Group {
            if transactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions Yet",
                    systemImage: "plus.capsule",
                    description: Text("Add your first transaction using the Add button.")
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
        #endif
    }

    // MARK: - Delete Action

    /// Deletes records at the offsets supplied by the iOS list.
    private func deleteTransactions(at offset: IndexSet) {
        for index in offset {
            modelContext.delete(transactions[index])
        }
    }

    #if os(macOS)
    // MARK: - Table Selection

    /// Resolves the selected table row to its current SwiftData model.
    private var selectedTransaction: Transaction? {
        guard let selection else { return nil }
        return transactions.first { $0.persistentModelID == selection }
    }

    /// Deletes the selected record and clears the table selection.
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
