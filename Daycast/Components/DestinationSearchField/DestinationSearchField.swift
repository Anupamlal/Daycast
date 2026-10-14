//
//  DestinationSearchField.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationSearchField: View {
    @Binding var text: String
    let onTextChange: () -> Void
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: DaycastSymbol.search.systemName)
                .foregroundStyle(DaycastAssetColor.accentBlue.color)
                .accessibilityHidden(true)

            TextField(DestinationSearchText.searchPlaceholder.value, text: $text)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                .onChange(of: text) { _, _ in
                    onTextChange()
                }
                .accessibilityLabel(DestinationSearchText.searchPlaceholder.value)

            if !text.isEmpty {
                Button(action: onClear) {
                    Image(systemName: DaycastSymbol.clear.systemName)
                        .foregroundStyle(DaycastAssetColor.secondaryText.color)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(DestinationSearchText.clearSearchAccessibilityLabel.value)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: DaycastLayoutMetric.searchFieldCornerRadius.value, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DaycastLayoutMetric.searchFieldCornerRadius.value, style: .continuous)
                .stroke(DaycastAssetColor.rowBorder.color, lineWidth: 1)
        )
    }
}
