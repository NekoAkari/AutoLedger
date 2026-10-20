//
//  Transaction.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import Foundation
import SwiftData
import SwiftUI

/// The income or expense direction associated with a transaction.
enum TransactionType: String, Codable {
    case income
    case expense
}

/// A transaction persisted by SwiftData.
@Model
final class Transaction {
    // MARK: - Properties

    var name: String
    /// The combined transaction date and time.
    var date: Date
    /// Form saves normalize this value to a positive amount and store direction in type.
    var amount: Double
    var type: TransactionType
    var category: String
    var note: String?

    // MARK: - Initializer

    /// Creates a record from transaction details; form validation is handled separately.
    init(
        name: String,
        date: Date,
        amount: Double,
        type: TransactionType,
        category: String,
        note: String? = nil
    ) {
        self.name = name
        self.date = date
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
    }

    // MARK: - Display Helpers

    /// Derives the display color from the stored transaction type.
    var displayColor: Color {
        type == .expense ? .red : .green
    }
}
