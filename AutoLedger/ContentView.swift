//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    #if os(macOS)
    @State private var selection: AppSection? = .summary
    #endif

    var body: some View {
        #if os(macOS)
        NavigationSplitView {
            List(AppSection.allCases, selection: $selection) { section in
                Label(section.title, systemImage: section.systemImage)
                    .tag(section)
            }
            .navigationTitle("AutoLedger")
            .listStyle(.sidebar)
        } detail: {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        #elseif os (iOS)
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
        #endif
    }
}

#if os(macOS)
private enum AppSection: String, CaseIterable, Identifiable {
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

#Preview {
    ContentView()
}
