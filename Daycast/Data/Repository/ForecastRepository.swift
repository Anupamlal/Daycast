//
//  ForecastRepository.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol ForecastRepository: Sendable {
    func cachedForecast(for destinationID: Int) -> DestinationForecastBundle?
    func isCacheValid(_ bundle: DestinationForecastBundle, at referenceDate: Date) -> Bool
    func loadForecast(
        for destination: Destination,
        intent: ForecastRefreshIntent
    ) async throws -> ForecastLoadResult
}

struct OpenMeteoForecastRepository: ForecastRepository {
    private let remoteService: WeatherForecastServicing
    private let cacheStore: ForecastCacheStoring

    init(
        remoteService: WeatherForecastServicing = OpenMeteoWeatherForecastService(),
        cacheStore: ForecastCacheStoring = UserDefaultsForecastCacheStore()
    ) {
        self.remoteService = remoteService
        self.cacheStore = cacheStore
    }

    func cachedForecast(for destinationID: Int) -> DestinationForecastBundle? {
        cacheStore.loadBundle(for: destinationID)
    }

    func isCacheValid(_ bundle: DestinationForecastBundle, at referenceDate: Date) -> Bool {
        bundle.isCacheValid(at: referenceDate)
    }

    func loadForecast(
        for destination: Destination,
        intent: ForecastRefreshIntent
    ) async throws -> ForecastLoadResult {
        if intent == .preferCache,
           let cached = cacheStore.loadBundle(for: destination.id),
           cached.isCacheValid(at: Date()) {
            return ForecastLoadResult(
                bundle: cached,
                source: .cache,
                availability: cached.availability
            )
        }

        do {
            let bundle = try await remoteService.fetchForecast(for: destination)
            cacheStore.saveBundle(bundle)
            return ForecastLoadResult(
                bundle: bundle,
                source: .network,
                availability: bundle.availability
            )
        } catch {
            if let cached = cacheStore.loadBundle(for: destination.id) {
                return ForecastLoadResult(
                    bundle: cached,
                    source: .cache,
                    availability: cached.availability
                )
            }
            throw ForecastRepositoryError.noCachedFallback
        }
    }
}
