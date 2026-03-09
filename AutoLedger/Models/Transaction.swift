//
//  Transaction.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import Foundation
import SwiftData

/// Represents a financial transacton
@Model
final class Transaction {
    
    // MARK: - Properties
    
    var date: Date
    var amount: Double
    var type: String
    var category: String
    var note: String?
    
    // MARK: - Initializer
    init(
        date: Date,
         amount: Double,
         type: String,
         category: String,
         note: String? = nil
    ) {
        self.date = date
        self.amount = amount
        self.type = type
        self.category = category
        self.note = note
    }
}
