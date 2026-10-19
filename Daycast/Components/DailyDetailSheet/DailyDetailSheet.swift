//
//  DailyDetailSheet.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DailyDetailSheet: View {
    let entry: RankingDayEntry
    let activity: Activity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DaycastLayoutMetric.sectionSpacing.value) {
                    if let evaluation = entry.evaluation {
                        summarySection(evaluation: evaluation)
                        conditionsSection
                        whySection(evaluation: evaluation)
                        factorSection(evaluation: evaluation)
                        safetySection(evaluation: evaluation)
                        activityCaveats
                    }
                }
                .padding(DaycastLayoutMetric.screenHorizontalPadding.value)
            }
            .background(DaycastAssetColor.canvasWarm.color.ignoresSafeArea())
            .navigationTitle(ActivityRankingText.dailyDetailTitle.value)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(DailyDetailText.closeAction.value) { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private func summarySection(evaluation: ActivityDayEvaluation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.formattedWeekdayDate)
                .font(.title3.weight(.bold))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            Text(activity.displayName)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)

            HStack(spacing: 12) {
                Text(String(format: ActivityRankingText.scoreFormat.value, evaluation.score))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                SuitabilityLabel(tier: evaluation.tier)
            }
        }
    }

    private var conditionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(ActivityRankingText.conditionsSectionTitle.value)
                .font(.headline)
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            conditionRow(
                title: ScoreFactorDisplayName.temperature.value,
                value: String(
                    format: ActivityRankingText.highLowTemperatureFormat.value,
                    ForecastDateFormatting.temperatureCelsius(entry.day.temperatureMaxCelsius).formattedValue,
                    ForecastDateFormatting.temperatureCelsius(entry.day.temperatureMinCelsius).formattedValue
                )
            )
            conditionRow(
                title: ActivityRankingText.precipitationLabel.value,
                value: String(format: ScoreFactorImpactText.precipitationFormat.value, entry.day.precipitationMillimeters)
            )
            conditionRow(
                title: ActivityRankingText.windLabel.value,
                value: String(format: ScoreFactorImpactText.windFormat.value, entry.day.windSpeedMaxKilometersPerHour)
            )
            if let sunshine = entry.day.sunshineDurationSeconds {
                conditionRow(
                    title: ActivityRankingText.sunshineLabel.value,
                    value: String(format: ScoreFactorImpactText.sunshineHoursFormat.value, sunshine / 3600)
                )
            }
        }
    }

    private func whySection(evaluation: ActivityDayEvaluation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ActivityRankingText.whyScoreSectionTitle.value)
                .font(.headline)
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
            Text(evaluation.summaryExplanation)
                .font(.body)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        }
    }

    private func factorSection(evaluation: ActivityDayEvaluation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(ActivityRankingText.factorBreakdownTitle.value)
                .font(.headline)
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            ForEach(evaluation.factors) { factor in
                FactorImpactRow(impact: factor)
            }
        }
    }

    @ViewBuilder
    private func safetySection(evaluation: ActivityDayEvaluation) -> some View {
        if let caution = evaluation.safetyCaution {
            VStack(alignment: .leading, spacing: 8) {
                Text(ActivityRankingText.safetySectionTitle.value)
                    .font(.headline)
                    .foregroundStyle(DaycastAssetColor.notSuitableRed.color)
                Text(caution)
                    .font(.footnote)
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.rowCornerRadius.value, style: .continuous)
                    .fill(DaycastAssetColor.notSuitableRed.color.opacity(0.08))
            )
        }
    }

    @ViewBuilder
    private var activityCaveats: some View {
        if activity == .surfing {
            caveatText(ActivityRankingText.surfingDetailDisclaimer.value)
        } else if activity == .skiing {
            caveatText(ActivityRankingText.skiingResortCaveat.value)
        }
    }

    private func caveatText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(DaycastAssetColor.secondaryText.color)
    }

    private func conditionRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
        }
    }
}
