import SwiftUI

#if os(iOS)
struct IOSTransactionListContent: View {
    let transactions: [Transaction]
    let deleteTransactions: (IndexSet) -> Void

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
    }
}
#endif
