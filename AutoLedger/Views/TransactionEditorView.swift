//
//  TransactionEditorView.swift
//  AutoLedger
//
//  Created by Akari on 2026-03-21.
//

import SwiftData
import SwiftUI

/// Edits an existing transaction using local values until Save is confirmed.
struct TransactionEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var transaction: Transaction

    // MARK: - Form State

    // Keep edits separate from the model so Cancel leaves the stored record unchanged.
    @State private var amountText: String = ""
    @State private var name: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var date: Date = .init()
    @State private var time: Date = .init()
    @State private var note: String = ""
    @State private var didAttemptSave = false

    /// Shared focus state for field navigation and validation feedback.
    @FocusState private var focusedField: TransactionFormField?

    /// Uses the same validation rules as transaction creation.
    private var canSave: Bool {
        TransactionFormSupport.canSave(amountText: amountText, name: name)
    }

    // MARK: - Form Layout

    var body: some View {
        TransactionFormFields(
            amountText: $amountText,
            name: $name,
            type: $type,
            category: $category,
            date: $date,
            time: $time,
            note: $note,
            focusedField: $focusedField,
            showValidationErrors: didAttemptSave
        )
        .navigationTitle("Edit Transaction")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                #if os(macOS)
                .keyboardShortcut(.cancelAction)
                #endif
            }

            ToolbarItem(placement: .confirmationAction) {
                SaveButton {
                    didAttemptSave = true

                    guard canSave else {
                        // Reveal all errors and move focus to the first invalid field.
                        focusedField = TransactionFormSupport.amountError(
                            for: amountText
                        ) != nil ? .amount : .name

                        return
                    }
                    saveEdits()
                    dismiss()
                }
            }
        }
        .onAppear {
            // Populate the local draft; only saveEdits writes values back to the model.
            amountText = String(transaction.amount)
            name = transaction.name
            type = transaction.type
            category = transaction.category
            date = transaction.date
            time = transaction.date
            note = transaction.note ?? ""
        }
    }

    // MARK: - Save Edits

    /// Applies valid form values, including negative-amount type conversion, to the model.
    private func saveEdits() {
        guard let values = TransactionFormSupport.normalizedValues(
            amountText: amountText, type: type
        ) else { return }

        // Preserve the selected day while taking the hour and minute from the time field.
        let combinedDate = Calendar.current.date(
            bySettingHour: Calendar.current.component(.hour, from: time),
            minute: Calendar.current.component(.minute, from: time),
            second: 0,
            of: date
        ) ?? date

        transaction.name = name
        transaction.amount = values.amount
        transaction.type = values.type
        transaction.category = category
        transaction.date = combinedDate
        transaction.note = note.isEmpty ? nil : note
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Transaction.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    let sample = Transaction(
        name: "Coffee",
        date: Date(),
        amount: 5.75,
        type: .expense,
        category: "Food",
        note: "Morning coffee"
    )

    container.mainContext.insert(sample)

    return TransactionEditorView(transaction: sample)
        .modelContainer(container)
}
