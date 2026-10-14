//
//  WeatherForecastServicing.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol WeatherForecastServicing: Sendable {
    func prefetchForecast(for destination: Destination) async throws -> CachedForecastSnapshot
}

struct OpenMeteoWeatherForecastService: WeatherForecastServicing {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }

    func prefetchForecast(for destination: Destination) async throws -> CachedForecastSnapshot {
        let endpoint = OpenMeteoEndpoint.forecast(
            latitude: destination.latitude,
            longitude: destination.longitude,
            forecastDays: OpenMeteoRequestParameter.forecastDayCount.intValue
        )
        let data = try await httpClient.data(from: endpoint.url)
        let response = try JSONDecoder().decode(OpenMeteoForecastResponse.self, from: data)
        let dayCount = response.daily?.time.count ?? 0
        return CachedForecastSnapshot(
            destinationID: destination.id,
            dayCount: dayCount,
            fetchedAt: Date()
        )
    }
}
