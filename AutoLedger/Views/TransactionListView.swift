//
//  TransactionListView.swift
//  AutoLedger
//
//  Created by Neko Akari on 2026-03-08.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
	
	@Query(sort: \Transaction.date, order: .reverse)
	private var transactions: [Transaction]
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(transactions) { transaction in
					HStack {
						VStack(alignment: .leading) {
							Text(transaction.category)
								.font(.headline)
							Text(transaction.date, format: .dateTime)
								.font(.caption)
								.foregroundColor(.gray)
						}
						Spacer()
						Text(transaction.amount, format: .currency(code: "CAD"))
							.foregroundColor(transaction.displayColor)
					}
				}
			}
			.navigationTitle("Transactions")
		}
	}
}

#Preview {
    TransactionListView()
		.modelContainer(for: Transaction.self, inMemory: true)
}
