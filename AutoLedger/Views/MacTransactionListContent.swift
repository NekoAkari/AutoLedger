import SwiftUI
import SwiftData

#if os(macOS)
struct MacTransactionListContent: View {
    let transactions: [Transaction]
    let filteredTransactions: [Transaction]
    @Binding var selection: PersistentIdentifier?
    @Binding var isEditingSelection: Bool
    @Binding var searchText: String
    let selectedTransaction: Transaction?
    let deleteSelectedTransaction: () -> Void

    var body: some View {
        HSplitView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Transactions")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                    Text("\(filteredTransactions.count) visible of \(transactions.count) total")
                        .foregroundStyle(.secondary)
                }

                if filteredTransactions.isEmpty {
                    ContentUnavailableView(
                        searchText.isEmpty ? "No Transactions Yet" : "No Matching Transactions",
                        systemImage: searchText.isEmpty ? "plus.capsule" : "magnifyingglass",
                        description: Text(searchText.isEmpty ? "Add your first transaction from the Add Transaction section." : "Try a different search term.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredTransactions, selection: $selection) { transaction in
                        Button {
                            selection = transaction.persistentModelID
                        } label: {
                            transactionListRow(for: transaction)
                        }
                        .buttonStyle(.plain)
                        .tag(transaction.persistentModelID)
                    }
                    .listStyle(.inset)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(.white.opacity(0.14), lineWidth: 1)
                    }
                }
            }
            .frame(minWidth: 380, idealWidth: 460, maxWidth: 540, maxHeight: .infinity, alignment: .topLeading)
            .padding(24)
            .searchable(text: $searchText, prompt: "Search name, category, or note")

            transactionDetailPane
        }
        .navigationTitle("Transactions")
        .onChange(of: selection) { _, _ in
            isEditingSelection = false
        }
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
    }

    @ViewBuilder
    private var transactionDetailPane: some View {
        if let selectedTransaction {
            if isEditingSelection {
                TransactionEditorView(
                    transaction: selectedTransaction,
                    showsToolbarButton: false,
                    onCancel: {
                        isEditingSelection = false
                    },
                    onSave: {
                        isEditingSelection = false
                    }
                )
                .frame(minWidth: 420, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(selectedTransaction.name)
                                        .font(.system(size: 28, weight: .bold, design: .rounded))

                                    HStack(spacing: 10) {
                                        Label(selectedTransaction.category, systemImage: "folder")
                                        Label(
                                            selectedTransaction.displayTypeLabel,
                                            systemImage: selectedTransaction.displaySymbolName
                                        )
                                    }
                                    .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Text(selectedTransaction.amount, format: .currency(code: CurrencySettings.currencyCode))
                                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                                    .foregroundStyle(selectedTransaction.displayColor)
                            }

                            Text(selectedTransaction.date, format: .dateTime.weekday(.wide).month(.wide).day().year().hour().minute())
                                .foregroundStyle(.secondary)
                        }

                        detailCard(title: "Transaction") {
                            detailRow("Type", value: selectedTransaction.displayTypeLabel)
                            detailRow("Category", value: selectedTransaction.category)
                            detailRow("Amount", value: selectedTransaction.amount.formatted(.currency(code: CurrencySettings.currencyCode)))
                            detailRow("Date", value: selectedTransaction.date.formatted(.dateTime.year().month(.abbreviated).day()))
                            detailRow("Time", value: selectedTransaction.date.formatted(.dateTime.hour().minute()))
                        }

                        detailCard(title: "Notes") {
                            if let note = selectedTransaction.note, !note.isEmpty {
                                Text(note)
                                    .textSelection(.enabled)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text("No note for this transaction.")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxWidth: 720, alignment: .leading)
                    .padding(24)
                }
                .frame(minWidth: 420, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        } else {
            ContentUnavailableView(
                "No Transaction Selected",
                systemImage: "rectangle.on.rectangle",
                description: Text("Choose a transaction from the list to inspect its details.")
            )
            .frame(minWidth: 420, maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }

    private func detailRow(_ title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            Text(title)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .trailing)

            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func transactionListRow(for transaction: Transaction) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(transaction.displayColor.opacity(0.18))
                .frame(width: 36, height: 36)
                .overlay {
                    Image(systemName: transaction.type == .expense ? "arrow.up" : "arrow.down")
                        .foregroundStyle(transaction.displayColor)
                        .font(.subheadline.weight(.semibold))
                }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(transaction.name)
                        .font(.headline)
                        .lineLimit(1)

                    Spacer(minLength: 8)

                    Text(transaction.date, format: .dateTime.hour().minute())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(transaction.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(transaction.displayTypeLabel)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)

                    Spacer(minLength: 8)

                    Text(transaction.amount, format: .currency(code: CurrencySettings.currencyCode))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(transaction.displayColor)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
#endif
