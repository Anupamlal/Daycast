//
//  ActivityRankingBuilderTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

final class ActivityRankingBuilderTests: XCTestCase {
    private let builder = ActivityRankingBuilder()
    private let destination = Destination(
        id: 1,
        name: "Queenstown",
        region: "Otago",
        country: "New Zealand",
        latitude: -45.03,
        longitude: 168.66
    )

    func testRankingSortsByDescendingScore() {
        let bundle = makeBundle(days: [
            makeDay(date: "2026-10-15", tempMax: 30, precip: 8, wind: 40),
            makeDay(date: "2026-10-16", tempMax: 22, precip: 0.2, wind: 12),
            makeDay(date: "2026-10-17", tempMax: 21, precip: 0.5, wind: 14),
        ])

        let snapshot = builder.buildRanking(for: .outdoorSightseeing, bundle: bundle)
        let rankedScores = snapshot.entries.compactMap { $0.evaluation?.score }

        XCTAssertEqual(rankedScores, rankedScores.sorted(by: >))
    }

    func testRankingTieBreaksByEarlierDate() {
        let bundle = makeBundle(days: [
            makeDay(date: "2026-10-16", tempMax: 22, precip: 0.2, wind: 12),
            makeDay(date: "2026-10-15", tempMax: 22, precip: 0.2, wind: 12),
        ])

        let snapshot = builder.buildRanking(for: .outdoorSightseeing, bundle: bundle)
        let rankedDates = snapshot.entries.compactMap { entry -> String? in
            guard entry.rank != nil else { return nil }
            return entry.day.date
        }

        XCTAssertEqual(rankedDates.first, "2026-10-15")
    }

    func testUnavailableDayIsNotRanked() {
        let bundle = makeBundle(days: [
            makeDay(date: "2026-10-15", tempMax: 22, precip: 0.2, wind: 12),
            makeDay(date: "2026-10-16", tempMax: 22, precip: 0.2, wind: 12),
        ])

        let snapshot = builder.buildRanking(
            for: .outdoorSightseeing,
            bundle: bundle,
            evaluateDay: { day, _ in
                guard day.date != "2026-10-16" else { return nil }
                return ActivityScoringEngine().evaluateDay(day: day, activity: .outdoorSightseeing)
            }
        )

        let unavailable = snapshot.entries.first { $0.day.date == "2026-10-16" }
        XCTAssertNotNil(unavailable)
        XCTAssertNil(unavailable?.rank)
        XCTAssertNil(unavailable?.evaluation)
    }

    func testSuitabilityBandsUseDocumentedThresholds() {
        XCTAssertEqual(SuitabilityTier.from(score: 70), .suitable)
        XCTAssertEqual(SuitabilityTier.from(score: 69), .uncertain)
        XCTAssertEqual(SuitabilityTier.from(score: 45), .uncertain)
        XCTAssertEqual(SuitabilityTier.from(score: 44), .notSuitable)
    }

    private func makeBundle(days: [ForecastDay]) -> DestinationForecastBundle {
        DestinationForecastBundle(
            destination: destination,
            timezoneIdentifier: "Pacific/Auckland",
            days: days,
            fetchedAt: Date(timeIntervalSince1970: 0)
        )
    }

    private func makeDay(
        date: String,
        tempMax: Double,
        precip: Double,
        wind: Double
    ) -> ForecastDay {
        ForecastDay(
            date: date,
            weatherCode: precip > 3 ? 61 : 1,
            temperatureMaxCelsius: tempMax,
            temperatureMinCelsius: tempMax - 5,
            precipitationMillimeters: precip,
            windSpeedMaxKilometersPerHour: wind,
            sunshineDurationSeconds: 14_400
        )
    }
}
