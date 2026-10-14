//
//  ActivityOverviewCard.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ActivityOverviewCard: View {
    let outlook: ActivityOutlookSummary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Image(systemName: outlook.activity.symbolName)
                        .font(.title3)
                        .foregroundStyle(DaycastAssetColor.accentBlue.color)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(outlook.activity.displayName)
                            .font(.headline)
                            .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                        if outlook.activity.showsSurfingWeatherProxyDisclosure {
                            Text(ActivityText.surfingProxyDisclosure.value)
                                .font(.caption2)
                                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                        }
                    }

                    Spacer(minLength: 0)

                    Image(systemName: DaycastSymbol.chevron.systemName)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(DaycastAssetColor.secondaryText.color)
                        .accessibilityHidden(true)
                }

                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    if let averageScore = outlook.averageScore, let tier = outlook.suitabilityTier {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ActivityOverviewText.outlookScoreLabel.value)
                                .font(.caption)
                                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                            Text(String(format: ActivityOverviewText.averageScoreFormat.value, averageScore))
                                .font(.title.weight(.bold))
                                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                            SuitabilityLabel(tier: tier)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(
                            String(
                                format: ActivityOverviewText.suitableDaysFormat.value,
                                outlook.suitableDayCount,
                                outlook.evaluatedDayCount
                            )
                        )
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                        if let coverageNote = outlook.coverageNote {
                            Text(coverageNote)
                                .font(.caption)
                                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                        }
                    }

                    Spacer(minLength: 0)
                }

                Text(outlook.reason)
                    .font(.footnote)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                    .stroke(DaycastAssetColor.rowBorder.color, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
