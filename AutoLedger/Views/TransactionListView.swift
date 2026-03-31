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

    @State private var selection: PersistentIdentifier?
    @State private var isEditingSelection = false
    @State private var searchText = ""
	
    var body: some View {
        #if os(macOS)
        MacTransactionListContent(
            transactions: transactions,
            filteredTransactions: filteredTransactions,
            selection: $selection,
            isEditingSelection: $isEditingSelection,
            searchText: $searchText,
            selectedTransaction: selectedTransaction,
            deleteSelectedTransaction: deleteSelectedTransaction
        )
        #else
        IOSTransactionListContent(
            transactions: transactions,
            deleteTransactions: deleteTransactions
        )
        #endif
    }
	
	// MARK: - Delete Action
	// Remove selected transaction from SwiftData.
	private func deleteTransactions(at offset:IndexSet) {
		for index in offset {
			modelContext.delete(transactions[index])
		}
    }

    private var filteredTransactions: [Transaction] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return transactions }

        return transactions.filter { transaction in
            transaction.name.localizedCaseInsensitiveContains(query)
            || transaction.category.localizedCaseInsensitiveContains(query)
            || (transaction.note?.localizedCaseInsensitiveContains(query) ?? false)
        }
    }

    private var selectedTransaction: Transaction? {
        guard let selection else { return nil }
        // Keep the selection stable even when the current search text temporarily hides the row.
        return filteredTransactions.first { $0.persistentModelID == selection }
            ?? transactions.first { $0.persistentModelID == selection }
    }

    private func deleteSelectedTransaction() {
        guard let selectedTransaction else { return }
        modelContext.delete(selectedTransaction)
        isEditingSelection = false
        selection = nil
    }
}

#Preview {
    TransactionListView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
