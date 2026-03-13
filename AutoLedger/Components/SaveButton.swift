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
			Image(systemName: "plus")
		}
		.buttonStyle(.borderedProminent)
		.tint(canSave ? .blue : .gray)
		.disabled(!canSave)
	}
}
