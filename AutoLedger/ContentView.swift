//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI

/// The adaptive tab navigation and presentation owner for transaction creation.
struct ContentView: View {
    // MARK: - Navigation State

    @State private var selection: AppSection = .summary
    @State private var isPresentingAddTransaction = false

    // MARK: - Main Layout

    var body: some View {
        TabView(selection: $selection) {
            Tab(
                "Summary",
                systemImage: "chart.bar.xaxis",
                value: AppSection.summary
            ) {
                navigationRoot {
                    SummaryView()
                }
            }

            Tab(
                "Transactions",
                systemImage: "list.bullet.rectangle.portrait",
                value: AppSection.transactions
            ) {
                navigationRoot {
                    TransactionListView()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .sheet(isPresented: $isPresentingAddTransaction) {
            NavigationStack {
                AddTransactionView(prefill: nil, onSave: {
                    // Finish the whole sheet, including any pushed receipt screens.
                    isPresentingAddTransaction = false
                })
            }
            #if os(macOS)
            .frame(width: 560, height: 560)
            #endif
        }
    }

    // MARK: - Navigation Root

    /// Gives each tab its own navigation stack and a shared Add action.
    private func navigationRoot<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack {
            content()
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isPresentingAddTransaction = true
                        } label: {
                            Label("Add Transaction", systemImage: "plus")
                        }
                        .keyboardShortcut("n", modifiers: .command)
                        .help("Add Transaction")
                    }
                }
        }
    }
}

/// Selectable destinations in the main tab view.
private enum AppSection: Hashable {
    case summary
    case transactions
}

#Preview {
    ContentView()
}
