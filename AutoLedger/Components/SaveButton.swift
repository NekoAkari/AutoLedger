//
//  SaveButton.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-13.
//

import SwiftUI

// MARK: - Save Button
struct SaveButton: View {
	let canSave: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
            #if os(macOS)
            Label("Save", systemImage: "plus.circle.fill")
            #else
			Image(systemName: "plus")
            #endif
		}
		.buttonStyle(.borderedProminent)
		.tint(canSave ? .accentColor : .gray)
		.disabled(!canSave)
	}
}
