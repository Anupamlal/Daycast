//
//  RankingDayEntry.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityRankingSnapshot: Sendable, Equatable {
    let destination: Destination
    let activity: Activity
    let timezoneIdentifier: String
    let entries: [RankingDayEntry]
    let lastUpdated: Date
}

struct RankingDayEntry: Identifiable, Sendable, Equatable {
    let day: ForecastDay
    let rank: Int?
    let evaluation: ActivityDayEvaluation?
    let timezoneIdentifier: String
    let isTopRanked: Bool

    var id: String { day.date }

    var isAvailable: Bool { evaluation != nil }

    var formattedWeekdayDate: String {
        RankingDateFormatting.weekdayDate(
            isoDay: day.date,
            timeZoneIdentifier: timezoneIdentifier
        )
    }

    var accessibilityLabel: String {
        if let rank, let evaluation {
            return String(
                format: RankingAccessibilityText.scoredDayLabel.value,
                rank,
                formattedWeekdayDate,
                evaluation.score,
                suitabilityLabel(for: evaluation.tier)
            )
        }
        return String(
            format: RankingAccessibilityText.unavailableDayLabel.value,
            formattedWeekdayDate
        )
    }

    private func suitabilityLabel(for tier: SuitabilityTier) -> String {
        switch tier {
        case .suitable: ActivityOverviewText.suitableLabel.value
        case .uncertain: ActivityOverviewText.uncertainLabel.value
        case .notSuitable: ActivityOverviewText.notSuitableLabel.value
        }
    }
}

enum ActivityRankingPresentationState: Equatable {
    case loading
    case loaded(ActivityRankingSnapshot)
    case error(showsRetry: Bool)
}

enum RankingDateFormatting {
    static func weekdayDate(isoDay: String, timeZoneIdentifier: String) -> String {
        guard let date = isoDayFormatter.date(from: isoDay) else { return isoDay }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        return formatter.string(from: date)
    }

    private static let isoDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

enum RankingAccessibilityText {
    case scoredDayLabel
    case unavailableDayLabel

    var value: String {
        switch self {
        case .scoredDayLabel: "Rank %d, %@, score %d, %@"
        case .unavailableDayLabel: "%@, forecast unavailable"
        }
    }
}
