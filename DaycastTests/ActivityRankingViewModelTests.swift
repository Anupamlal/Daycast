//
//  ActivityRankingViewModelTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

@MainActor
final class ActivityRankingViewModelTests: XCTestCase {
    func testLoadedStateAfterSuccessfulForecast() async {
        let destination = Destination(
            id: 99,
            name: "Test",
            region: nil,
            country: "Country",
            latitude: 1,
            longitude: 2
        )
        let route = ActivityRankingRoute(destination: destination, activity: .outdoorSightseeing)
        let forecast = DestinationForecastBundle(
            destination: destination,
            timezoneIdentifier: "UTC",
            days: [
                ForecastDay(
                    date: "2026-10-15",
                    weatherCode: 1,
                    temperatureMaxCelsius: 22,
                    temperatureMinCelsius: 12,
                    precipitationMillimeters: 0,
                    windSpeedMaxKilometersPerHour: 10,
                    sunshineDurationSeconds: 10_000
                ),
            ],
            fetchedAt: Date()
        )

        let viewModel = ActivityRankingViewModel(
            route: route,
            forecastRepository: MockForecastRepository(bundle: forecast)
        )

        viewModel.onAppear()
        try? await Task.sleep(for: .milliseconds(150))

        guard case .loaded = viewModel.presentationState else {
            return XCTFail("Expected loaded state")
        }
    }
}

private struct MockForecastRepository: ForecastRepository {
    let bundle: DestinationForecastBundle

    func cachedForecast(for destinationID: Int) -> DestinationForecastBundle? {
        bundle.destination.id == destinationID ? bundle : nil
    }

    func isCacheValid(_ bundle: DestinationForecastBundle, at referenceDate: Date) -> Bool {
        true
    }

    func loadForecast(
        for destination: Destination,
        intent: ForecastRefreshIntent
    ) async throws -> ForecastLoadResult {
        ForecastLoadResult(bundle: bundle, source: .cache, availability: bundle.availability)
    }
}
