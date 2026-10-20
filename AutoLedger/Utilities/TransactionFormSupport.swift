//
//  TransactionFormSupport.swift
//  AutoLedger
//
//  Created by Akari on 2026-10-14.
//

import Foundation

/// Shared validation and amount normalization for transaction forms.
enum TransactionFormSupport {
    // MARK: - Amount Validation

    /// Accept a leading minus sign and up to two fractional digits.
    private static let amountPattern = #"\A-?[0-9]*(\.[0-9]{0,2})?\z"#

    /// Parses a signed amount with an absolute value of at least 0.01.
    /// Returns nil for incomplete input, extra decimal places, or nonfinite values.
    static func amount(from text: String) -> Double? {
        guard text.range(
            of: amountPattern,
            options: .regularExpression
        ) != nil,
            let value = Double(text),
            value.isFinite,
            abs(value) >= 0.01
        else {
            return nil
        }
        return value
    }

    /// Uses the same validation rules as the inline error messages.
    static func canSave(amountText: String, name: String) -> Bool {
        amountError(for: amountText) == nil
            && nameError(for: name) == nil
    }

    // MARK: - Storage Values

    /// Returns a positive amount and the transaction type to store.
    /// Negative input reverses the selected type; positive input keeps it.
    static func normalizedValues(
        amountText: String,
        type: TransactionType
    ) -> (
        amount: Double,
        type: TransactionType
    )? {
        guard let signedAmount = amount(from: amountText) else {
            return nil
        }

        let savedType: TransactionType

        // The stored type carries the direction, so the stored amount stays positive.
        if signedAmount < 0 {
            savedType = type == .income ? .expense : .income
        } else {
            savedType = type
        }

        return (
            amount: abs(signedAmount),
            type: savedType
        )
    }

    // MARK: - Validation Messages

    /// Returns an amount error message, or nil when the input is valid.
    static func amountError(for text: String) -> String? {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter an amount."
        }

        guard amount(from: text) != nil else {
            return "Enter a nonzero amount with up to two decimal places."
        }
        return nil
    }

    /// Requires a name containing more than whitespace or newlines.
    static func nameError(for name: String) -> String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Enter a transaction name."
        }
        return nil
    }
}
