//
//  ActivityScoringEngineTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

final class ActivityScoringEngineTests: XCTestCase {
    private let engine = ActivityScoringEngine()

    func testIndoorScoreIsIndependentFromOutdoorScore() {
        let day = ForecastDay(
            date: "2026-10-15",
            weatherCode: 61,
            temperatureMaxCelsius: 30,
            temperatureMinCelsius: 22,
            precipitationMillimeters: 8,
            windSpeedMaxKilometersPerHour: 40,
            sunshineDurationSeconds: 1_000
        )

        let outdoor = engine.evaluateDay(day: day, activity: .outdoorSightseeing)?.score
        let indoor = engine.evaluateDay(day: day, activity: .indoorSightseeing)?.score

        XCTAssertNotNil(outdoor)
        XCTAssertNotNil(indoor)
        XCTAssertGreaterThan(indoor ?? 0, outdoor ?? 0)
    }

    func testSevereWeatherSurfacesSafetyCaution() {
        let day = ForecastDay(
            date: "2026-10-15",
            weatherCode: 95,
            temperatureMaxCelsius: 20,
            temperatureMinCelsius: 12,
            precipitationMillimeters: 5,
            windSpeedMaxKilometersPerHour: 20,
            sunshineDurationSeconds: 3_000
        )

        let evaluation = engine.evaluateDay(day: day, activity: .outdoorSightseeing)
        XCTAssertNotNil(evaluation?.safetyCaution)
    }

    func testAllActivitiesProduceScoresForCompleteDay() {
        let day = ForecastDay(
            date: "2026-10-15",
            weatherCode: 1,
            temperatureMaxCelsius: 22,
            temperatureMinCelsius: 12,
            precipitationMillimeters: 0.5,
            windSpeedMaxKilometersPerHour: 12,
            sunshineDurationSeconds: 10_000
        )

        for activity in Activity.allCases {
            XCTAssertNotNil(engine.evaluateDay(day: day, activity: activity))
        }
    }
}
