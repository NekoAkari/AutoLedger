import SwiftUI

#if os(iOS)
struct IOSContentView: View {
    var body: some View {
        TabView {
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "rectangle.stack")
                }
            TransactionListView()
                .tabItem {
                    Label("Transactions", systemImage: "scroll")
                }
            AddTransactionView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }
        }
    }
}
#endif
