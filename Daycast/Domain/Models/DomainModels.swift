//
//  DomainModels.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

/// Canonical domain names used across features (see docs/ARCHITECTURE.md).
typealias ActivityType = Activity
typealias DailyForecast = ForecastDay

struct ActivityScore: Sendable, Equatable {
    let activity: ActivityType
    let day: DailyForecast
    let value: Int
    let tier: SuitabilityTier
    let factorImpacts: [ScoreFactorImpact]

    init(evaluation: ActivityDayEvaluation, activity: ActivityType, day: DailyForecast) {
        self.activity = activity
        self.day = day
        self.value = evaluation.score
        self.tier = evaluation.tier
        self.factorImpacts = evaluation.factors
    }
}

/// Ranked activity outlook for one destination (Screen 3 domain output).
typealias ActivityRanking = ActivityRankingSnapshot
