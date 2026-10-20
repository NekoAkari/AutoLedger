//
//  AddTransactionView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftData
import SwiftUI

#if os(iOS)
private extension View {
    /// Resigns the active UIKit text responder to dismiss the keyboard.
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
#endif

/// Creates a transaction from manual entry or a receipt draft.
struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// Optional receipt values applied once when the form appears.
    let prefill: ReceiptDraft?
    /// The presentation owner closes the whole creation flow after a valid save.
    let onSave: () -> Void

    // MARK: - Form State

    @State private var amountText: String = ""
    @State private var name: String = ""
    @State private var date: Date = .init()
    @State private var time: Date = .init()
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var note: String = ""
    // Preserve user edits when returning from another screen in the navigation stack.
    @State private var didApplyPrefill = false
    // Keep an untouched form free of validation messages until Save is attempted.
    @State private var didAttemptSave = false

    /// Tracks focus for keyboard dismissal and validation feedback.
    @FocusState private var focusedField: TransactionFormField?

    /// Whether the current form values pass the shared save validation.
    private var canSave: Bool {
        TransactionFormSupport.canSave(amountText: amountText, name: name)
    }

    // MARK: - Save Transaction

    /// Inserts a normalized transaction into the context, then resets local form state.
    private func saveTransaction() {
        guard let values = TransactionFormSupport.normalizedValues(
            amountText: amountText,
            type: type
        ) else {
            return
        }

        // Combine the selected date and time into one Date value for storage
        let combinedDate = Calendar.current.date(
            bySettingHour: Calendar.current.component(.hour, from: time),
            minute: Calendar.current.component(.minute, from: time),
            second: 0,
            of: date
        ) ?? date

        let transaction = Transaction(
            name: name,
            date: combinedDate,
            amount: values.amount,
            type: values.type,
            category: category,
            note: note.isEmpty ? nil : note
        )

        // Insert the record into the SwiftData context.
        modelContext.insert(transaction)

        // Reset the form after saving
        amountText = ""
        name = ""
        date = Date()
        time = Date()
        category = ""
        note = ""
        type = .expense
        focusedField = nil

        #if os(iOS)
        hideKeyboard()
        #endif
    }

    // MARK: - Save and Finish

    /// Shows validation errors or completes the save and notifies the sheet owner.
    private func saveAndFinish() {
        didAttemptSave = true

        guard canSave else {
            // Amount is the first required field, followed by the transaction name.
            focusedField = TransactionFormSupport.amountError(for: amountText)
                != nil ? .amount : .name
            return
        }

        saveTransaction()
        didAttemptSave = false
        onSave()
    }

    // MARK: - Prefill

    /// Copies detected receipt values without reapplying them on later appearances.
    private func applyPrefillIfNeeded() {
        guard let prefill, !didApplyPrefill else { return }

        if !prefill.merchant.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            name = prefill.merchant
        }

        if let amount = prefill.amount {
            // Display two decimal places and retain the sign for save-time conversion.
            amountText = String(format: "%.2f", amount)
        }

        if let parsedDate = prefill.date {
            date = parsedDate
            time = parsedDate
        }

        if !prefill.rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            note = prefill.rawText
        }

        didApplyPrefill = true
    }

    // MARK: - Form Layout

    var body: some View {
        #if os(macOS)
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
        .navigationTitle("Add Transaction")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }

            ToolbarItem(placement: .navigation) {
                NavigationLink {
                    ReceiptScanView(onSave: onSave)
                } label: {
                    Label("Scan Receipt", systemImage: "doc.viewfinder")
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                SaveButton {
                    saveAndFinish()
                }
                .keyboardShortcut(.defaultAction)
            }
        }

        .onAppear {
            applyPrefillIfNeeded()
        }
        .onSubmit {
            focusedField = nil
        }
        #elseif os(iOS)
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
        .navigationTitle("Add Transaction")
        .onAppear {
            applyPrefillIfNeeded()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .secondaryAction) {
                NavigationLink {
                    ReceiptScanView(onSave: onSave)
                } label: {
                    Label("Scan Receipt", systemImage: "doc.viewfinder")
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                SaveButton {
                    saveAndFinish()
                }
            }

            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    focusedField = nil
                    hideKeyboard()
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
            hideKeyboard()
        }
        .scrollDismissesKeyboard(.immediately)
        .onSubmit {
            focusedField = nil
            hideKeyboard()
        }
        #endif
    }
}

#Preview {
    NavigationStack {
        AddTransactionView(
            prefill: nil,
            onSave: {}
        )
    }
    .modelContainer(for: Transaction.self, inMemory: true)
}
