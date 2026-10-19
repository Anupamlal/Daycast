//
//  DaycastExplainerCard.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DaycastExplainerCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(DaycastExplainerText.title.value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            Text(DaycastExplainerText.body.value)
                .font(.footnote)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                .stroke(DaycastAssetColor.rowBorder.color, lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}
