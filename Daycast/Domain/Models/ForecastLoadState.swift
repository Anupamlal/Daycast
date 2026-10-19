//
//  ForecastLoadState.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ForecastDataSource: Sendable, Equatable {
    case cache
    case network
}

struct ForecastLoadResult: Sendable, Equatable {
    let bundle: DestinationForecastBundle
    let source: ForecastDataSource
    let availability: ForecastAvailability
}

enum ForecastRefreshIntent: Sendable {
    case preferCache
    case forceNetwork
}

enum ForecastRepositoryError: Error, Equatable {
    case networkFailure
    case invalidResponse
    case noCachedFallback
}
