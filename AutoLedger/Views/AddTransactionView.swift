//
//  AddTransactionView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

#if os(iOS)
private extension View {
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

struct AddTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Form State
    @State private var amountText: String = ""
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var note: String = ""
    
    // Tracks which text field is currently active so the keyboard can be dismissed
    @FocusState private var focusedField: TransactionFormField?
    
    // Save is only enabled when the user enters a valid amount and a non‑empty name
    private var canSave: Bool {
        if let value = Double(amountText) {
            return value > 0 && !name.trimmingCharacters(in: .whitespaces).isEmpty
        }
        return false;
    }
    
    // MARK: - Save Transaction
    private func saveTransaction() {
        
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
            amount: Double(amountText) ?? 0,
            type: type,
            category: category,
            note: note.isEmpty ? nil : note
        )
        
        // Save the transaction to SwiftData
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
            focusedField: $focusedField
        )
        .navigationTitle("Add Transaction")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                SaveButton(canSave: canSave) {
                    saveTransaction()
                }
            }
        }
        .frame(maxWidth: 720, maxHeight: .infinity, alignment: .topLeading)
        .onSubmit {
            focusedField = nil
        }
        #elseif os (iOS)
        NavigationStack {
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
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    SaveButton(canSave: canSave) {
                        saveTransaction()
                    }
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
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
        }
        #endif
    }
}

#Preview {
    AddTransactionView()
}
