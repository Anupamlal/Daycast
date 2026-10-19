//
//  OpenMeteoForecastMapperTests.swift
//  DaycastTests
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import XCTest
@testable import Daycast

final class OpenMeteoForecastMapperTests: XCTestCase {
    private let destination = Destination(
        id: 1,
        name: "Queenstown",
        region: "Otago",
        country: "New Zealand",
        latitude: -45.03,
        longitude: 168.66
    )

    func testValidResponseMapsToBundle() throws {
        let json = """
        {
          "timezone": "Pacific/Auckland",
          "daily": {
            "time": ["2026-10-15"],
            "weather_code": [1],
            "temperature_2m_max": [18.0],
            "temperature_2m_min": [8.0],
            "precipitation_sum": [0.2],
            "wind_speed_10m_max": [12.0],
            "sunshine_duration": [36000]
          }
        }
        """
        let response = try JSONDecoder().decode(OpenMeteoForecastResponse.self, from: Data(json.utf8))
        let bundle = try OpenMeteoForecastMapper.map(
            response: response,
            destination: destination,
            fetchedAt: Date(timeIntervalSince1970: 0)
        )

        XCTAssertEqual(bundle.timezoneIdentifier, "Pacific/Auckland")
        XCTAssertEqual(bundle.days.count, 1)
        XCTAssertEqual(bundle.days.first?.date, "2026-10-15")
    }

    func testMissingDailyPayloadThrows() {
        let response = OpenMeteoForecastResponse(daily: nil, timezone: "UTC")
        XCTAssertThrowsError(
            try OpenMeteoForecastMapper.map(
                response: response,
                destination: destination,
                fetchedAt: .now
            )
        ) { error in
            XCTAssertEqual(error as? ForecastMappingError, .missingDailyPayload)
        }
    }
}
