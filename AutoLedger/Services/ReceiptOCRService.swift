//
//  ReceiptOCRService.swift
//  AutoLedger
//
//  Created by Akari on 2026-05-11.
//

import Foundation
import Vision

#if os(iOS)
import UIKit

typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit

typealias PlatformImage = NSImage
#endif

/// Recognizes receipt text with Vision and creates a draft using basic parsing.
/// Merchant and amount detection are estimates; date detection is not implemented yet.
struct ReceiptOCRService {
    // MARK: - Public API

    /// Returns the best text candidate for each observation in a receipt image.
    /// Throws when the image cannot provide a CGImage or Vision reports an error.
    func recognizeText(from image: PlatformImage) async throws -> [String] {
        guard let cgImage = image.cgImageForOCR else {
            throw ReceiptOCRError.invalidImage
        }

        // Bridge Vision's completion handler to the async interface.
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observation = request.results as? [VNRecognizedTextObservation] ?? []

                let lines = observation.compactMap { observation in observation.topCandidates(1).first?.string }

                continuation.resume(returning: lines)
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    /// Creates a draft with estimated fields and retains the raw recognized text.
    func creatDraft(from image: PlatformImage) async throws -> ReceiptDraft {
        let lines = try await recognizeText(from: image)
        let rawText = lines.joined(separator: "\n")

        return ReceiptDraft(
            merchant: detectMerchant(from: lines),
            amount: detectAmount(from: lines),
            date: detectDate(from: lines),
            tax: nil,
            currencyCode: CurrencySettings.currencyCode,
            rawText: rawText,
            recognizedLines: lines
        )
    }

    // MARK: - Basic Parsing Helpers

    /// Estimates the merchant from the first non-empty recognized line.
    private func detectMerchant(from lines: [String]) -> String {
        lines.first { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ?? ""
    }

    /// Estimates the amount from the largest decimal match in the recognized text.
    /// This heuristic does not distinguish totals from other receipt amounts.
    private func detectAmount(from lines: [String]) -> Double? {
        let text = lines.joined(separator: " ")
        let pattern = #"\d+\.\d{2}"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }

        let range = NSRange(text.startIndex ..< text.endIndex, in: text)
        let matches = regex.matches(in: text, range: range)
        let amounts = matches.compactMap { matches -> Double? in
            guard let range = Range(matches.range, in: text) else {
                return nil
            }
            return Double(text[range])
        }
        return amounts.max()
    }

    /// Date parsing is a placeholder and currently returns nil.
    private func detectDate(from lines: [String]) -> Date? {
        nil
    }
}

// MARK: - Errors

/// Image conversion errors raised before a Vision recognition request is performed.
enum ReceiptOCRError: Error {
    case invalidImage
}

// MARK: - Platform Image Helpers

private extension PlatformImage {
    /// Provides the CGImage representation required by Vision on each platform.
    var cgImageForOCR: CGImage? {
#if os(iOS)
        return cgImage
#elseif os(macOS)
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
#endif
    }
}
