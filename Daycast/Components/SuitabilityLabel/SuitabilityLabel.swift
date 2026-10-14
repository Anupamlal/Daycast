//
//  SuitabilityLabel.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct SuitabilityLabel: View {
    let tier: SuitabilityTier

    var body: some View {
        Text(labelText)
            .font(.caption.weight(.semibold))
            .foregroundStyle(SuitabilityStatusColor(tier: tier).color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(SuitabilityStatusColor(tier: tier).color.opacity(0.12))
            )
            .accessibilityLabel(labelText)
    }

    private var labelText: String {
        switch tier {
        case .suitable: ActivityOverviewText.suitableLabel.value
        case .uncertain: ActivityOverviewText.uncertainLabel.value
        case .notSuitable: ActivityOverviewText.notSuitableLabel.value
        }
    }
}
