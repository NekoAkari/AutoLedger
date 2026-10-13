//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: AppSection = .summary
    @State private var isPresentingAddTransaction = false

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
                    isPresentingAddTransaction = false
                })
            }
            #if os(macOS)
            .frame(minWidth: 560, minHeight: 520)
            #endif
        }
    }

    // MARK: - Navigation Root

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

private enum AppSection: Hashable {
    case summary
    case transactions
}

#Preview {
    ContentView()
}
