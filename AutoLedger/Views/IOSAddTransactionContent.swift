import SwiftUI

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

struct IOSAddTransactionContent: View {
    @Binding var amountText: String
    @Binding var name: String
    @Binding var type: TransactionType
    @Binding var category: String
    @Binding var date: Date
    @Binding var time: Date
    @Binding var note: String
    var focusedField: FocusState<TransactionFormField?>.Binding
    let canSave: Bool
    let saveTransaction: () -> Void

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
                focusedField: focusedField
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
                focusedField.wrappedValue = nil
                hideKeyboard()
            }
            .scrollDismissesKeyboard(.immediately)
            .onSubmit {
                focusedField.wrappedValue = nil
                hideKeyboard()
            }
        }
    }
}
#endif
