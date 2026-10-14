//
//  DestinationHistorySheetView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationHistorySheetView: View {
    let records: [RecentDestinationRecord]
    let onSelect: (RecentDestinationRecord) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(records) { record in
                        RecentDestinationRow(record: record) {
                            onSelect(record)
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, DaycastLayoutMetric.screenHorizontalPadding.value)
                .padding(.vertical, 12)
            }
            .background(DaycastAssetColor.canvasWarm.color.ignoresSafeArea())
            .navigationTitle(DestinationSearchText.historySheetTitle.value)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
