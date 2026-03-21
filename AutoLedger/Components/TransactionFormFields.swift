//
//  TransactionFormFields.swift
//  AutoLedger
//
//  Created by Akari on 2026-03-21.
//
import SwiftUI
import SwiftData

enum TransactionFormField: Hashable {
    case amount
    case name
    case category
    case note
}

struct TransactionFormFields: View {
    @Binding var amountText: String
    @Binding var name: String
    @Binding var type: TransactionType
    @Binding var category: String
    @Binding var date: Date
    @Binding var time: Date
    @Binding var note: String
    
    var focusedField: FocusState<TransactionFormField?>.Binding
    
    var body: some View {
        Form {
            Section("Amount") {
                HStack {
                    Text(CurrencySettings.currencySymbol)
                        .foregroundStyle(.secondary)
                    
                    TextField("0.00", text: $amountText)
                        .focused(focusedField, equals: .amount)
                }
                #if os(iOS)
                .keyboardType(.decimalPad)
                #endif
            }
            
            Section("Name") {
                TextField("Transaction name", text: $name)
                    .focused(focusedField, equals: .name)
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
                    .focused(focusedField, equals: .category)
            }
            
            Section("Date") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            
            Section("Time") {
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
            }
            
            Section("Note") {
                TextField("Optional note", text: $note)
                    .focused(focusedField, equals: .note)
            }
        }
    }
}
