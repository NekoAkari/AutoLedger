//
//  ReceiptDraft.swift
//  AutoLedger
//
//  Created by Akari on 2026-04-07.
//

import Foundation

/// Temporary receipt data for preview and prefill before a transaction is saved.
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

    /// The full recognized text, retained for preview and transaction notes.
    var rawText: String = ""
    /// Individual text lines returned by the recognition service.
    var recognizedLines: [String] = []

    // MARK: - Validation Helpers

    /// Reports whether an amount was detected, without validating it for saving.
    var hasDetectedAmount: Bool {
        amount != nil
    }

    /// Reports whether a date was detected.
    var hasDetectedDate: Bool {
        date != nil
    }

    /// Treats whitespace-only merchant text as missing.
    var hasDetectedMerchant: Bool {
        !merchant.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Reports whether the main parsed fields and raw text are missing.
    var isMostlyEmpty: Bool {
        !hasDetectedAmount && !hasDetectedDate && !hasDetectedMerchant && rawText.isEmpty
    }
}
