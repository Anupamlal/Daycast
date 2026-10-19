//
//  DestinationLocationRow.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationLocationRow: View {
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: DaycastSymbol.location.systemName)
                    .foregroundStyle(DaycastAssetColor.accentBlue.color)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                        .multilineTextAlignment(.leading)

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(DaycastAssetColor.secondaryText.color)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: DaycastSymbol.chevron.systemName)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, DaycastLayoutMetric.rowVerticalPadding.value)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.rowCornerRadius.value, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.rowCornerRadius.value, style: .continuous)
                    .stroke(DaycastAssetColor.rowBorder.color, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
