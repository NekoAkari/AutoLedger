//
//  AddTransactionView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

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
        
    }
    
    var body: some View {
        #if os(macOS)
        MacAddTransactionContent(
            amountText: $amountText,
            name: $name,
            type: $type,
            category: $category,
            date: $date,
            time: $time,
            note: $note,
            focusedField: $focusedField,
            canSave: canSave,
            saveTransaction: saveTransaction
        )
        #else
        IOSAddTransactionContent(
            amountText: $amountText,
            name: $name,
            type: $type,
            category: $category,
            date: $date,
            time: $time,
            note: $note,
            focusedField: $focusedField,
            canSave: canSave,
            saveTransaction: saveTransaction
        )
        #endif
    }
}

#Preview {
    AddTransactionView()
}
