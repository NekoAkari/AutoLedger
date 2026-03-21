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
    
    @State private var amountText: String = ""
    @State private var name: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()
    @State private var note: String = ""
    
    @FocusState private var focusedField: TransactionFormField?
    
    var body: some View {
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
            .navigationTitle("Edit Transaction")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        saveEdits()
                        dismiss()
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
    }
    
    private func saveEdits() {
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
