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

/// Handles OCR text recognition for receipt images.
///
/// This service only focuses on image-to-text conversion and creating a basic 'ReceiptDraft'.
/// More advanced receipt parsing, such as detecting totals, taxes, or merchants more accurately, can be moved into separate parser service later.

struct ReceiptOCRService {
    
    // MARK: - Public API
    /// Recognizes text lines from a receipt image.
    func recognizeText(from image: PlatformImage) async throws -> [String] {
        guard let cgImage = image.cgImageForOCR else {
            throw ReceiptOCRError.invalidImage
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                
                let observation = request.results as? [VNRecognizedTextObservation] ?? []
                
                let lines = observation.compactMap { observation in observation.topCandidates(1).first?.string}
                
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
    
    /// Creates a basic receipt draft from an image using OCR.
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
    /// Very simple merchant guess: use the first non-empty line.
    private func detectMerchant(from lines: [String]) -> String {
        lines.first { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ?? ""
    }
    
    /// Very simple ampunt guess: find the largest number that looks like a money amount.
    private func detectAmount(from lines: [String]) -> Double? {
        let text = lines.joined(separator: " ")
        let pattern = #"\d+\.\d{2}"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        let matches = regex.matches(in: text, range: range)
        let amounts = matches.compactMap { matches -> Double? in
            guard let range = Range(matches.range, in: text) else {
                return nil
            }
            return Double(text[range])
        }
        return amounts.max()
    }
    
    /// Basic date detection placeholder.
    private func detectDate(from lines: [String]) -> Date? {
        nil
    }
}

// MARK: - Errors
enum ReceiptOCRError: Error {
    case invalidImage
}

// MARK: - Platform Image Helpers
private extension PlatformImage {
    var cgImageForOCR: CGImage? {
#if os(iOS)
        return cgImage
#elseif os(macOS)
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
#endif
    }
}
