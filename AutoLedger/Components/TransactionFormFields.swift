//
//  TransactionFormFields.swift
//  AutoLedger
//
//  Created by Akari on 2026-03-21.
//
import SwiftUI

/// Text fields that can receive focus during entry or validation.
enum TransactionFormField: Hashable {
    case amount
    case name
    case category
    case note
}

/// Shared transaction inputs for creation and editing, with platform-specific layouts.
struct TransactionFormFields: View {
    // MARK: - Form Bindings

    @Binding var amountText: String
    @Binding var name: String
    @Binding var type: TransactionType
    @Binding var category: String
    @Binding var date: Date
    @Binding var time: Date
    @Binding var note: String

    /// Lets the parent dismiss the keyboard or focus the first invalid field.
    var focusedField: FocusState<TransactionFormField?>.Binding

    // MARK: - Validation Feedback

    /// The parent reveals errors after the first Save attempt.
    var showValidationErrors: Bool = false

    private var amountError: String? {
        showValidationErrors ? TransactionFormSupport.amountError(for: amountText) : nil
    }

    private var nameError: String? {
        showValidationErrors ? TransactionFormSupport.nameError(for: name) : nil
    }

    // MARK: - Form Layout

    var body: some View {
        Form {
            #if os(macOS)
            Section("Transaction") {
                LabeledContent("Amount") {
                    HStack(spacing: 8) {
                        Text(CurrencySettings.currencySymbol)
                            .foregroundStyle(.secondary)

                        TextField("Amount", text: $amountText, prompt: Text("0.00"))
                            .labelsHidden()
                            .focused(focusedField, equals: .amount)
                            .frame(maxWidth: 100)
                    }
                }

                fieldError("Amount", message: amountError)

                TextField("Name", text: $name, prompt: Text("Transaction name"))
                    .focused(focusedField, equals: .name)

                fieldError("Name", message: nameError)

                Picker("Type", selection: $type) {
                    Text("Expense").tag(TransactionType.expense)
                    Text("Income").tag(TransactionType.income)
                }
                .pickerStyle(.segmented)
            }

            Section("Details") {
                TextField("Category", text: $category, prompt: Text("Optional"))
                    .focused(focusedField, equals: .category)

                DatePicker("Date", selection: $date, displayedComponents: .date)
                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
            }

            Section("Note") {
                TextField("Note", text: $note, prompt: Text("Optional note"), axis: .vertical)
                    .labelsHidden()
                    .lineLimit(3 ... 5)
                    .focused(focusedField, equals: .note)
            }
            #else
            Section("Amount") {
                HStack {
                    Text(CurrencySettings.currencySymbol)
                        .foregroundStyle(.secondary)

                    TextField("0.00", text: $amountText)
                        .focused(focusedField, equals: .amount)
                }
                #if os(iOS)
                // Signed amounts need a keyboard that includes the minus key.
                .keyboardType(.numbersAndPunctuation)
                #endif

                fieldError("Amount", message: amountError)
            }

            Section("Name") {
                TextField("Transaction name", text: $name)
                    .focused(focusedField, equals: .name)

                fieldError("Name", message: nameError)
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
            #endif
        }
        #if os(macOS)
        .formStyle(.grouped)
        #endif
    }

    // MARK: - Inline Errors

    /// Pairs the error text with an icon so feedback does not depend on color alone.
    @ViewBuilder
    private func fieldError(
        _ title: String,
        message: String?
    ) -> some View {
        if let message {
            Label(
                "\(title): \(message)",
                systemImage: "exclamationmark.circle.fill"
            )
            .font(.caption)
            .foregroundStyle(.red)
            .fixedSize(horizontal: false, vertical: false)
        }
    }
}
