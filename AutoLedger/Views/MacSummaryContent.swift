import SwiftUI
import SwiftData

#if os(macOS)
struct MacSummaryContent: View {
    let transactions: [Transaction]
    let totals: TransactionTotals

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    Text("\(transactions.count) transactions across your current ledger.")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(minimum: 260), spacing: 16),
                        GridItem(.flexible(minimum: 260), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    SummaryCard(title: "Balance", amount: totals.balance, color: .primary, systemImage: "scale.3d")
                    SummaryCard(title: "Income", amount: totals.income, color: .green, systemImage: "arrow.down.circle.fill")
                    SummaryCard(title: "Expense", amount: totals.expense, color: .red, systemImage: "arrow.up.circle.fill")
                    summaryPanel
                }

                if !transactions.isEmpty {
                    recentTransactionsPanel
                }
            }
            .frame(maxWidth: 920, alignment: .leading)
            .padding(24)
        }
        .navigationTitle("Summary")
    }

    private var summaryPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Snapshot")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(balanceTone)
                .font(.title3.weight(.semibold))

            Text("Updated from your full transaction history in real time.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }

    private var recentTransactionsPanel: some View {
        let recentTransactions = Array(transactions.prefix(5))

        return VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.title3.weight(.semibold))

            ForEach(Array(recentTransactions.enumerated()), id: \.element.persistentModelID) { index, transaction in
                HStack(spacing: 12) {
                    Circle()
                        .fill(transaction.displayColor.opacity(0.18))
                        .frame(width: 34, height: 34)
                        .overlay {
                            Image(systemName: transaction.type == .expense ? "arrow.up" : "arrow.down")
                                .foregroundStyle(transaction.displayColor)
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(transaction.name)
                            .fontWeight(.medium)
                        Text(transaction.date, format: .dateTime.month().day().hour().minute())
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(transaction.amount, format: .currency(code: CurrencySettings.currencyCode))
                        .foregroundStyle(transaction.displayColor)
                }

                if index < recentTransactions.count - 1 {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.white.opacity(0.14), lineWidth: 1)
        }
    }

    private var balanceTone: String {
        if totals.balance > 0 {
            return "Net positive this period."
        } else if totals.balance < 0 {
            return "Spending is ahead of income."
        } else {
            return "Income and expense are balanced."
        }
    }
}
#endif
