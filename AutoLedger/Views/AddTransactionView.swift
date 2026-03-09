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

    @State private var amount: Double = 0
    @State private var name: String = ""
    @State private var time: Date = Date()
    @State private var date: Date = Date()
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Amount") {
                    TextField("Amount", value: $amount, format: .number)
#if os(iOS)
                        .keyboardType(.decimalPad)
#endif
                }
                
                Section("Name") {
                    TextField("Transaction name", text: $name)
                }

                Section("Type") {
                    Picker("Type", selection: $type) {
                        Text("Expense").tag(TransactionType.expense)
                        Text("Income").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                }

                Section("Category") {
                    TextField("Category", text: $category)
                }

                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("Time") {
                    DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                }
                
                Section("Note") {
                    TextField("Optional note", text: $note)
                }

                Button("Save Transaction") {
                    let combinedDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: time),
                        minute: Calendar.current.component(.minute, from: time),
                        second: 0,
                        of: date
                    ) ?? date
                    
                    let transaction = Transaction(
                        date: combinedDate,
                        amount: amount,
                        type: type,
                        category: category,
                        note: note.isEmpty ? nil : note
                    )

                    modelContext.insert(transaction)

                    amount = 0
                    name = ""
                    time = Date()
                    category = ""
                    note = ""
                    date = Date()
                    type = .expense
                }
            }
            .navigationTitle("Add Transaction")
        }
    }
}

#Preview {
    AddTransactionView()
}
