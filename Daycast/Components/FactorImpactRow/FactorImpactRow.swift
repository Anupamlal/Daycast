//
//  FactorImpactRow.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct FactorImpactRow: View {
    let impact: ScoreFactorImpact

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: polaritySymbol)
                .foregroundStyle(polarityColor)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(ScoreFactorDisplayName.from(kind: impact.factor).value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                Text(impact.observedValue)
                    .font(.caption)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)

                Text(impact.impactDescription)
                    .font(.footnote)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    private var polaritySymbol: String {
        switch impact.polarity {
        case .positive: FactorImpactSymbol.positive.systemName
        case .negative: FactorImpactSymbol.negative.systemName
        case .neutral: FactorImpactSymbol.neutral.systemName
        case .unavailable: FactorImpactSymbol.unavailable.systemName
        }
    }

    private var polarityColor: Color {
        switch impact.polarity {
        case .positive: DaycastAssetColor.suitableGreen.color
        case .negative: DaycastAssetColor.notSuitableRed.color
        case .neutral: DaycastAssetColor.secondaryText.color
        case .unavailable: DaycastAssetColor.secondaryText.color
        }
    }
}

enum FactorImpactSymbol {
    case positive
    case negative
    case neutral
    case unavailable

    var systemName: String {
        switch self {
        case .positive: "plus.circle.fill"
        case .negative: "minus.circle.fill"
        case .neutral: "circle.fill"
        case .unavailable: "questionmark.circle"
        }
    }
}
