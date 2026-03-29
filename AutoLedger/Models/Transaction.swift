//
//  Transaction.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import Foundation
import SwiftData
import SwiftUI

/// Represents a financial transaction
enum TransactionType: String, Codable {
    case income
    case expense
}

@Model
final class Transaction {

    // MARK: - Properties
    var name: String
    var date: Date
    var amount: Double
    var type: TransactionType
    var category: String
    var note: String?;

    // MARK: - Initializer
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

    // Keep UI color mapping derived from the transaction type.
    var displayColor: Color {
        type == .expense ? .red : .green
    }
}
