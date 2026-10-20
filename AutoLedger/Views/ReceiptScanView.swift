//
//  ReceiptScanView.swift
//  AutoLedger
//
//  Created by Akari on 2026-04-07.
//

import SwiftData
import SwiftUI

/// Previews a mock receipt and passes its values to the transaction creation form.
/// The current scan action simulates recognition and does not call ReceiptOCRService.
struct ReceiptScanView: View {
    /// Forwarded to the prefilled form so Save can close the entire creation sheet.
    let onSave: () -> Void

    // MARK: - Scan State

    @State private var draft = ReceiptDraft()
    @State private var isScanning: Bool = false
    @State private var hasResult: Bool = false
    @State private var goToAdd = false
    // MARK: - Scan Layout

    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Scan Button

            Button {
                simulateScan()
            } label: {
                Label("Scan Receipt", systemImage: "camera")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            if isScanning {
                ProgressView("Scanning…")
                    .progressViewStyle(.circular)
            }

            // MARK: - Result Preview

            if hasResult {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preview")
                        .font(.headline)

                    Text("Merchant: \(draft.merchant)")
                    Text("Amount: \(draft.amount ?? 0)")
                    Text("Date: \(draft.date?.formatted() ?? "-")")

                    Divider()

                    Text("Raw Text")
                        .font(.subheadline)

                    Text(draft.rawText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray))
                .cornerRadius(12)

                Button {
                    goToAdd = true
                } label: {
                    Text("Use This Result")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Scan Again") {
                    hasResult = false
                }
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Scan Receipt")
        .navigationDestination(isPresented: $goToAdd) {
            // Let the user review and edit recognized values before saving a record.
            AddTransactionView(prefill: draft, onSave: onSave)
        }
    }

    // MARK: - Temporary Mock

    /// Simulates a short scan delay, then supplies a fixed receipt for the preview flow.
    private func simulateScan() {
        isScanning = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            draft = ReceiptDraft(
                merchant: "Starbucks",
                amount: 6.45,
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 7)),
                tax: 0.45,
                currencyCode: "CAD",
                rawText: "STARBUCKS\n2026-04-07\nAmount 6.45\n Tax 0.45",
                recognizedLines: ["STARBUCKS", "2026-04-07", "Amount 6.45", "Tax 0.45"]
            )

            hasResult = true
            isScanning = false
        }
    }
}

#Preview {
    NavigationStack {
        ReceiptScanView(onSave: {})
    }
    .modelContainer(for: Transaction.self, inMemory: true)
}
