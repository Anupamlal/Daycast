//
//  ForecastRepositoryTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

final class ForecastRepositoryTests: XCTestCase {
    private let destination = Destination(
        id: 42,
        name: "Berlin",
        region: "Berlin",
        country: "Germany",
        latitude: 52.52,
        longitude: 13.41
    )

    func testPreferCacheReturnsValidCachedBundle() async throws {
        let bundle = makeBundle(fetchedAt: Date())
        let repository = OpenMeteoForecastRepository(
            remoteService: FailingForecastService(),
            cacheStore: InMemoryForecastCacheStore(initial: bundle)
        )

        let result = try await repository.loadForecast(for: destination, intent: .preferCache)
        XCTAssertEqual(result.source, .cache)
        XCTAssertEqual(result.bundle.destination.id, 42)
    }

    func testNetworkFailureFallsBackToCache() async throws {
        let staleDate = Date().addingTimeInterval(-ForecastCachePolicy.timeToLiveSeconds.timeInterval - 10)
        let bundle = makeBundle(fetchedAt: staleDate)
        let repository = OpenMeteoForecastRepository(
            remoteService: FailingForecastService(),
            cacheStore: InMemoryForecastCacheStore(initial: bundle)
        )

        let result = try await repository.loadForecast(for: destination, intent: .forceNetwork)
        XCTAssertEqual(result.source, .cache)
        XCTAssertEqual(result.bundle.days.count, 1)
    }

    func testCacheValidityUsesSixHourTTL() {
        let repository = OpenMeteoForecastRepository()
        let fresh = makeBundle(fetchedAt: Date())
        let stale = makeBundle(fetchedAt: Date().addingTimeInterval(-ForecastCachePolicy.timeToLiveSeconds.timeInterval - 1))

        XCTAssertTrue(repository.isCacheValid(fresh, at: Date()))
        XCTAssertFalse(repository.isCacheValid(stale, at: Date()))
    }

    private func makeBundle(fetchedAt: Date) -> DestinationForecastBundle {
        DestinationForecastBundle(
            destination: destination,
            timezoneIdentifier: "Europe/Berlin",
            days: [
                ForecastDay(
                    date: "2026-10-15",
                    weatherCode: 1,
                    temperatureMaxCelsius: 20,
                    temperatureMinCelsius: 10,
                    precipitationMillimeters: 0,
                    windSpeedMaxKilometersPerHour: 8,
                    sunshineDurationSeconds: 8_000
                ),
            ],
            fetchedAt: fetchedAt
        )
    }
}

private struct FailingForecastService: WeatherForecastServicing {
    func fetchForecast(for destination: Destination) async throws -> DestinationForecastBundle {
        throw OpenMeteoServiceError.invalidResponse
    }
}

private final class InMemoryForecastCacheStore: ForecastCacheStoring, @unchecked Sendable {
    private var bundle: DestinationForecastBundle?

    init(initial: DestinationForecastBundle? = nil) {
        bundle = initial
    }

    func loadBundle(for destinationID: Int) -> DestinationForecastBundle? {
        guard bundle?.destination.id == destinationID else { return nil }
        return bundle
    }

    func saveBundle(_ bundle: DestinationForecastBundle) {
        self.bundle = bundle
    }
}
