//
//  TransactionEditorView.swift
//  AutoLedger
//
//  Created by Akari on 2026-03-21.
//

import SwiftUI
import SwiftData

struct TransactionEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var transaction: Transaction
    // The editor can either own its toolbar action or be embedded inline inside the macOS detail pane.
    var showsToolbarButton: Bool = true
    var onCancel: (() -> Void)? = nil
    var onSave: (() -> Void)? = nil
    
    @State private var amountText: String = ""
    @State private var name: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var note: String = ""
    
    @FocusState private var focusedField: TransactionFormField?

    private var canSave: Bool {
        if let value = Double(amountText) {
            return value > 0 && !name.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return false
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TransactionFormFields(
                amountText: $amountText,
                name: $name,
                type: $type,
                category: $category,
                date: $date,
                time: $time,
                note: $note,
                focusedField: $focusedField
            )
            .navigationTitle("Edit Transaction")

            if !showsToolbarButton {
                Divider()

                HStack {
                    Button("Cancel") {
                        onCancel?()
                    }

                    Spacer()

                    Button {
                        guard canSave else { return }
                        saveEdits()
                        onSave?()
                    } label: {
                        Label("Save Changes", systemImage: "checkmark.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!canSave)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
            }
        }
        .toolbar {
            if showsToolbarButton {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        guard canSave else { return }
                        saveEdits()
                        onSave?()
                        dismiss()
                    } label: {
                        #if os(macOS)
                        Label("Done", systemImage: "checkmark.circle.fill")
                        #else
                        Image(systemName: "checkmark")
                        #endif
                    }
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            amountText = String(transaction.amount)
            name = transaction.name
            type = transaction.type
            category = transaction.category
            date = transaction.date
            time = transaction.date
            note = transaction.note ?? ""
        }
    }
    
    private func saveEdits() {
        // Persist the date and time pickers as one stored timestamp on the model.
        let combinedDate = Calendar.current.date(
            bySettingHour: Calendar.current.component(.hour, from: time),
            minute: Calendar.current.component(.minute, from: time),
            second: 0,
            of: date
        ) ?? date
        
        transaction.name = name
        transaction.amount = Double(amountText) ?? 0
        transaction.type = type
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
