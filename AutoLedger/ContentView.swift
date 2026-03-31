//
//  ContentView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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

#Preview {
    ContentView()
}
