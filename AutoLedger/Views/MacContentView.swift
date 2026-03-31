import SwiftUI

#if os(macOS)
struct MacContentView: View {
    @State private var selection: AppSection? = .summary

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section("Workspace") {
                    ForEach(AppSection.allCases) { section in
                        Label(section.title, systemImage: section.systemImage)
                            .tag(section)
                    }
                }
            }
            .navigationTitle("AutoLedger")
            .listStyle(.sidebar)
        } detail: {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(nsColor: .windowBackgroundColor),
                        Color.accentColor.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Group {
                    switch selection ?? .summary {
                    case .summary:
                        SummaryView()
                    case .transactions:
                        TransactionListView()
                    case .add:
                        AddTransactionView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

enum AppSection: String, CaseIterable, Identifiable {
    case summary
    case transactions
    case add

    var id: String { rawValue }

    var title: String {
        switch self {
        case .summary:
            return "Summary"
        case .transactions:
            return "Transactions"
        case .add:
            return "Add Transaction"
        }
    }

    var systemImage: String {
        switch self {
        case .summary:
            return "rectangle.stack"
        case .transactions:
            return "scroll"
        case .add:
            return "plus.circle"
        }
    }
}
#endif
