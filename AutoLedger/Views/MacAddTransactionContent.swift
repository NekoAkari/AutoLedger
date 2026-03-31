import SwiftUI

#if os(macOS)
struct MacAddTransactionContent: View {
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
            ToolbarItem(placement: .primaryAction) {
                SaveButton(canSave: canSave) {
                    saveTransaction()
                }
            }
        }
        .frame(maxWidth: 720, maxHeight: .infinity, alignment: .topLeading)
        .onSubmit {
            focusedField.wrappedValue = nil
        }
    }
}
#endif
