//
//  AutoLedgerApp.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftUI
import SwiftData

@main
struct AutoLedgerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 1180, height: 760)
        #endif
        .modelContainer(sharedModelContainer)
    }
}
