import SwiftUI

#if os(iOS)
struct IOSSummaryContent: View {
    let totals: TransactionTotals

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                SummaryCard(title: "Balance", amount: totals.balance, color: .primary, systemImage: "scale.3d")
                SummaryCard(title: "Income", amount: totals.income, color: .green, systemImage: "arrow.down.circle.fill")
                SummaryCard(title: "Expense", amount: totals.expense, color: .red, systemImage: "arrow.up.circle.fill")

                Spacer()
            }
            .padding()
            .navigationTitle("Summary")
        }
    }
}
#endif
