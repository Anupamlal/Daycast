//
//  ActivityScoringEngine.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityDailyScore: Sendable, Equatable {
    let day: ForecastDay
    let score: Int
}

struct ActivityScoringEngine: Sendable {
    func evaluateDay(day: ForecastDay, activity: Activity) -> ActivityDayEvaluation? {
        guard let score = score(day: day, activity: activity) else { return nil }
        return ActivityDayEvaluation(
            score: score,
            tier: SuitabilityTier.from(score: score),
            summaryExplanation: ActivityDayExplanationBuilder.summary(for: activity, day: day, score: score),
            factors: ActivityFactorImpactBuilder.factors(for: activity, day: day),
            safetyCaution: SevereWeatherDetector.cautionMessage(for: day)
        )
    }

    func buildOutlooks(for bundle: DestinationForecastBundle) -> [ActivityOutlookSummary] {
        Activity.allCases.map { activity in
            buildOutlook(for: activity, days: bundle.days)
        }
    }

    func buildOutlook(for activity: Activity, days: [ForecastDay]) -> ActivityOutlookSummary {
        let scoredDays = days.compactMap { day -> ActivityDailyScore? in
            guard let score = score(day: day, activity: activity) else { return nil }
            return ActivityDailyScore(day: day, score: score)
        }

        let suitableThreshold = ActivityScoringPolicy.suitableDayThreshold.intValue
        let suitableCount = scoredDays.filter { $0.score >= suitableThreshold }.count
        let validCount = scoredDays.count
        let expectedCount = ActivityScoringPolicy.forecastDayCount.intValue

        let averageScore: Int? = {
            guard !scoredDays.isEmpty else { return nil }
            let total = scoredDays.reduce(0) { $0 + $1.score }
            return total / scoredDays.count
        }()

        let reason = ActivityReasonBuilder.reason(for: activity, scoredDays: scoredDays)
        let coverageNote: String? = validCount < expectedCount
            ? String(
                format: ActivityOverviewText.partialCoverageFormat.value,
                validCount,
                expectedCount
            )
            : nil

        return ActivityOutlookSummary(
            activity: activity,
            averageScore: averageScore,
            suitableDayCount: suitableCount,
            evaluatedDayCount: validCount,
            expectedDayCount: expectedCount,
            reason: reason,
            coverageNote: coverageNote
        )
    }

    private func score(day: ForecastDay, activity: Activity) -> Int? {
        switch activity {
        case .skiing: scoreSkiing(day: day)
        case .surfing: scoreSurfing(day: day)
        case .outdoorSightseeing: scoreOutdoorSightseeing(day: day)
        case .indoorSightseeing: scoreIndoorSightseeing(day: day)
        }
    }

    private func scoreSkiing(day: ForecastDay) -> Int {
        let coldScore = clampScore(100 - Int(max(0, day.temperatureMaxCelsius - 2) * 8))
        let snowBonus = WeatherCodeCategory.from(code: day.weatherCode).isSnowPrecipitation ? 20 : 0
        let precipPenalty = min(40, Int(day.precipitationMillimeters * 10))
        return clampScore(coldScore + snowBonus - precipPenalty)
    }

    private func scoreSurfing(day: ForecastDay) -> Int {
        let tempScore = bellScore(
            value: day.temperatureMaxCelsius,
            ideal: 24,
            tolerance: 8
        )
        let windScore = bellScore(
            value: day.windSpeedMaxKilometersPerHour,
            ideal: 20,
            tolerance: 12
        )
        let precipPenalty = min(50, Int(day.precipitationMillimeters * 12))
        return clampScore((tempScore + windScore) / 2 - precipPenalty)
    }

    private func scoreOutdoorSightseeing(day: ForecastDay) -> Int {
        let tempScore = bellScore(
            value: day.temperatureMaxCelsius,
            ideal: 22,
            tolerance: 10
        )
        let precipPenalty = min(60, Int(day.precipitationMillimeters * 15))
        let windPenalty = min(25, Int(max(0, day.windSpeedMaxKilometersPerHour - 30)))
        return clampScore(tempScore - precipPenalty - windPenalty)
    }

    private func scoreIndoorSightseeing(day: ForecastDay) -> Int {
        let outdoor = scoreOutdoorSightseeing(day: day)
        let adverseBoost = 100 - outdoor
        return clampScore((outdoor / 3) + (adverseBoost * 2 / 3))
    }

    private func bellScore(value: Double, ideal: Double, tolerance: Double) -> Int {
        let delta = abs(value - ideal)
        let normalized = max(0, 100 - Int((delta / tolerance) * 100))
        return clampScore(normalized)
    }

    private func clampScore(_ value: Int) -> Int {
        min(100, max(0, value))
    }
}

enum WeatherCodeCategory {
    case clear
    case rain
    case snow
    case other

    var isSnowPrecipitation: Bool {
        self == .snow
    }

    static func from(code: Int) -> WeatherCodeCategory {
        switch code {
        case 0, 1, 2, 3: .clear
        case 71, 73, 75, 77, 85, 86: .snow
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: .rain
        default: .other
        }
    }
}
