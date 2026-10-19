//
//  RankingDayRow.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct RankingDayRow: View {
    let entry: RankingDayEntry
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(rankAndDateTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                        if let evaluation = entry.evaluation {
                            Text(evaluation.summaryExplanation)
                                .font(.footnote)
                                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text(ActivityRankingText.forecastUnavailable.value)
                                .font(.footnote)
                                .foregroundStyle(DaycastAssetColor.secondaryText.color)
                        }
                    }

                    Spacer(minLength: 8)

                    ScoreBadge(score: entry.evaluation?.score, tier: entry.evaluation?.tier)
                }

                ScoreBar(score: entry.evaluation?.score)
            }
            .padding(16)
            .frame(minHeight: 88)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                    .stroke(borderColor, lineWidth: entry.isTopRanked ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(entry.accessibilityLabel)
    }

    private var rankAndDateTitle: String {
        if let rank = entry.rank {
            return String(
                format: ActivityRankingText.rankPrefixFormat.value,
                rank,
                entry.formattedWeekdayDate
            )
        }
        return entry.formattedWeekdayDate
    }

    private var borderColor: Color {
        if entry.isTopRanked {
            return DaycastAssetColor.accentBlue.color.opacity(0.45)
        }
        return DaycastAssetColor.rowBorder.color
    }
}
