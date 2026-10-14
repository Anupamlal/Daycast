//
//  OpenMeteoForecastResponse.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct OpenMeteoForecastResponse: Decodable, Sendable {
    let daily: OpenMeteoDailyForecast?
}

struct OpenMeteoDailyForecast: Decodable, Sendable {
    let time: [String]
}

struct CachedForecastSnapshot: Codable, Sendable, Equatable {
    let destinationID: Int
    let dayCount: Int
    let fetchedAt: Date
}
