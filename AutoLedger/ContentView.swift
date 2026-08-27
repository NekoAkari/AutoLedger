//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: AppSection = .summary
    
    var body: some View {
        TabView(selection: $selection) {
            Tab(
                "Summary",
                systemImage: "chart.bar.xaxis",
                value: AppSection.summary
            ) {
                SummaryView()
            }
            
            Tab(
                "Transactions",
                systemImage: "list.bullet.rectangle.portrait",
                value: AppSection.transactions
            ) {
                TransactionListView()
            }
            
            Tab(
                "Add",
                systemImage: "plus.capsule",
                value: AppSection.add
            ) {
                AddTransactionView(prefill: nil)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

private enum AppSection: Hashable {
    case summary
    case transactions
    case add
}

#Preview {
    ContentView()
}
