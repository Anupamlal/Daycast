//
//  ForecastAvailability.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ForecastAvailability: Equatable, Sendable {
    case complete(dayCount: Int)
    case partial(availableDays: Int, expectedDays: Int)
    case unavailable

    var isUsable: Bool {
        switch self {
        case .complete, .partial: true
        case .unavailable: false
        }
    }
}

extension DestinationForecastBundle {
    var availability: ForecastAvailability {
        let expected = ActivityScoringPolicy.forecastDayCount.intValue
        let count = days.count
        if count == 0 {
            return .unavailable
        }
        if count < expected {
            return .partial(availableDays: count, expectedDays: expected)
        }
        return .complete(dayCount: count)
    }

    func isCacheValid(at referenceDate: Date) -> Bool {
        referenceDate.timeIntervalSince(fetchedAt) < ForecastCachePolicy.timeToLiveSeconds.timeInterval
    }
}
