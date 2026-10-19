//
//  ActivityDayEvaluation.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityDayEvaluation: Sendable, Equatable {
    let score: Int
    let tier: SuitabilityTier
    let summaryExplanation: String
    let factors: [ScoreFactorImpact]
    let safetyCaution: String?
}

struct ScoreFactorImpact: Identifiable, Sendable, Equatable {
    let factor: ScoreFactorKind
    let observedValue: String
    let polarity: FactorImpactPolarity
    let impactDescription: String

    var id: String { factor.rawValue }
}

enum ScoreFactorKind: String, Sendable {
    case temperature
    case precipitation
    case wind
    case sunshine
    case weatherPattern
    case indoorShelter
}

enum FactorImpactPolarity: Sendable {
    case positive
    case negative
    case neutral
    case unavailable
}
