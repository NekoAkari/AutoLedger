//
//  TransactionFormFields.swift
//  AutoLedger
//
//  Created by Akari on 2026-03-21.
//
import SwiftUI

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
        #if os(macOS)
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Transaction Details")
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text("Use precise values and categories so the ledger stays easy to scan.")
                        .foregroundStyle(.secondary)
                }

                GroupBox {
                    // Desktop forms read better with labels aligned in one column.
                    VStack(alignment: .leading, spacing: 16) {
                        macOSRow("Amount") {
                            HStack(spacing: 8) {
                                Text(CurrencySettings.currencySymbol)
                                    .foregroundStyle(.secondary)

                                TextField("0.00", text: $amountText)
                                    .textFieldStyle(.roundedBorder)
                                    .focused(focusedField, equals: .amount)
                            }
                        }

                        macOSRow("Name") {
                            TextField("Transaction name", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .focused(focusedField, equals: .name)
                        }

                        macOSRow("Type") {
                            Picker("Type", selection: $type) {
                                Text("Expense").tag(TransactionType.expense)
                                Text("Income").tag(TransactionType.income)
                            }
                            .pickerStyle(.segmented)
                        }

                        macOSRow("Category") {
                            TextField("Category", text: $category)
                                .textFieldStyle(.roundedBorder)
                                .focused(focusedField, equals: .category)
                        }

                        macOSRow("Date") {
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .labelsHidden()
                        }

                        macOSRow("Time") {
                            DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                    }
                    .padding(20)
                }

                GroupBox {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Note")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        TextEditor(text: $note)
                            .font(.body)
                            .focused(focusedField, equals: .note)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.background.opacity(0.8))
                            )
                    }
                    .padding(20)
                }
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(24)
        }
        #else
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
        #endif
    }

    #if os(macOS)
    @ViewBuilder
    private func macOSRow<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Text(title)
                .foregroundStyle(.secondary)
                .frame(width: 110, alignment: .trailing)

            content()
                .frame(maxWidth: 420, alignment: .leading)
        }
    }
    #endif
}
