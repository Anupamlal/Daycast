//
//  DestinationForecastBundle.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct DestinationForecastBundle: Codable, Sendable, Equatable {
    let destination: Destination
    let timezoneIdentifier: String
    let days: [ForecastDay]
    let fetchedAt: Date

    func isCacheValid(at referenceDate: Date) -> Bool {
        let lifetime = TimeInterval(DestinationSearchPolicy.forecastCacheLifetimeSeconds.intValue)
        return referenceDate.timeIntervalSince(fetchedAt) < lifetime
    }
}

struct ForecastDay: Codable, Sendable, Equatable, Identifiable {
    let date: String
    let weatherCode: Int
    let temperatureMaxCelsius: Double
    let temperatureMinCelsius: Double
    let precipitationMillimeters: Double
    let windSpeedMaxKilometersPerHour: Double
    let sunshineDurationSeconds: Double?

    var id: String { date }
}

struct CachedForecastSnapshot: Codable, Sendable, Equatable {
    let destinationID: Int
    let dayCount: Int
    let fetchedAt: Date
}
