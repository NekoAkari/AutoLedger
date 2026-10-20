//
//  SaveButton.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-13.
//

import SwiftUI

// MARK: - Save Button

/// A shared Save control that lets the caller validate input and show errors.
struct SaveButton: View {
    /// Called on every Save attempt, including attempts with invalid form values.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Save", systemImage: "checkmark")
        }
        .buttonStyle(.borderedProminent)
        .help("Save Transaction")
    }
}
