//
//  EmptyHistoryView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct EmptyHistoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(DestinationSearchText.emptyHistoryTitle.value)
                .font(.headline)
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            Text(DestinationSearchText.emptyHistoryMessage.value)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}
