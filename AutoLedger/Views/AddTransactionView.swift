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
	@State private var amount: Double = 0
	@State private var name: String = ""
	@State private var time: Date = Date()
	@State private var date: Date = Date()
	@State private var type: TransactionType = .expense
	@State private var category: String = ""
	@State private var note: String = ""
	
	// Tracks which text field is currently active so the keyboard can be dismissed.
	@FocusState private var focusedField: Field?
	
	enum Field {
		case amount
		case name
		case category
		case note
	}
	
	// Save is only enabled when the user enters a valid amount and a non-empty name.
	private var canSave: Bool {
		amount > 0 && !name.trimmingCharacters(in: .whitespaces).isEmpty
	}
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Amount") {
					TextField("Amount", value: $amount, format: .currency(code:"CAD"))
						.focused($focusedField, equals: .amount)
#if os(iOS)
						.keyboardType(.decimalPad)
#endif
				}
				
				Section("Name") {
					TextField("Transaction name", text: $name)
						.focused($focusedField, equals: .name)
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
						.focused($focusedField, equals: .category)
				}
				
				Section("Date") {
					DatePicker("Date", selection: $date, displayedComponents: .date)
				}
				
				Section("Time") {
					DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
				}
				
				Section("Note") {
					TextField("Optional note", text: $note)
						.focused($focusedField, equals: .note)
				}
				
				Button("Save Transaction") {
					// Combine the selected date and time into one Date value for storage.
					let combinedDate = Calendar.current.date(
						bySettingHour: Calendar.current.component(.hour, from: time),
						minute: Calendar.current.component(.minute, from: time),
						second: 0,
						of: date
					) ?? date
					
					let transaction = Transaction(
						name: name,
						date: combinedDate,
						amount: amount,
						type: type,
						category: category,
						note: note.isEmpty ? nil : note
					)
					
					// Save the transaction to SwiftData
					modelContext.insert(transaction)
					
					// Reset the form after saving
					amount = 0
					name = ""
					time = Date()
					date = Date()
					category = ""
					note = ""
					type = .expense
					focusedField = nil
				}
				.disabled(!canSave)
				.opacity(canSave ? 1 : 0.5)
			}
			.navigationTitle("Add Transaction")
			.toolbar {
				ToolbarItemGroup(placement: .keyboard) {
					Spacer()
					Button {
						focusedField = nil
					} label: {
						Image(systemName: "checkmark.circle.fill")
					}
				}
			}
			.scrollDismissesKeyboard(.interactively)
			.onSubmit {
				focusedField = nil
			}
		}
	}
}


#Preview {
    AddTransactionView()
}
