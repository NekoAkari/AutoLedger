//
//  ReceiptDraft.swift
//  AutoLedger
//
//  Created by Akari on 2026-04-07.
//

import Foundation

/// A temporary receipt model used to hold OCR results before the user confirms and saves a transaction.
struct ReceiptDraft {
    
    // MARK: - Basic Parsed Fields
    var merchant: String = ""
    var amount: Double?
    var date: Date?
    var time: Date?
    
    // MARK: - Optional Extra Information
    var tax: Double?
    var account: String?
    var location: String?
    var currencyCode: String = CurrencySettings.currencyCode
    
    // MARK: - Raw OCR Output
    var rawText: String = ""
    var recognizedLines: [String] = []
    
    // MARK: - Validation Helpers
    var hasDetectedAmount: Bool {
        amount != nil
    }
    
    var hasDetectedDate: Bool {
        date != nil
    }
    
    var hasDetectedMerchant: Bool {
        !merchant.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isMostlyEmpty: Bool {
        !hasDetectedAmount && !hasDetectedDate && !hasDetectedMerchant && rawText.isEmpty
    }
}
