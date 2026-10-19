//
//  ActivityScoringPolicy.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityScoringPolicy {
    case suitableDayThreshold
    case uncertainThreshold
    case forecastDayCount

    var intValue: Int {
        switch self {
        case .suitableDayThreshold: 70
        case .uncertainThreshold: 45
        case .forecastDayCount: 7
        }
    }
}

enum SuitabilityTier {
    case suitable
    case uncertain
    case notSuitable

    static func from(score: Int) -> SuitabilityTier {
        if score >= ActivityScoringPolicy.suitableDayThreshold.intValue {
            return .suitable
        }
        if score >= ActivityScoringPolicy.uncertainThreshold.intValue {
            return .uncertain
        }
        return .notSuitable
    }

    static func from(averageScore: Int) -> SuitabilityTier {
        from(score: averageScore)
    }
}
