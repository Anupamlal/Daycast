//
//  ScoreBadge.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ScoreBadge: View {
    let score: Int?
    let tier: SuitabilityTier?

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            if let score, let tier {
                Text(String(format: ActivityRankingText.scoreFormat.value, score))
                    .font(.headline.weight(.bold))
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                SuitabilityLabel(tier: tier)
            } else {
                Text(ActivityRankingText.scoreUnavailable.value)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
