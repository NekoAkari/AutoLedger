//
//  AutoLedgerApp.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-05.
//

import SwiftData
import SwiftUI

/// The app entry point and owner of the shared SwiftData container.
@main
struct AutoLedgerApp: App {
    // MARK: - Data Container

    /// Uses persistent storage and shares the transaction context across app windows.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Transaction views require a usable container before the app can start.
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - App Scene

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
