//
//  WeatherForecastServicing.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol WeatherForecastServicing: Sendable {
    func fetchForecast(for destination: Destination) async throws -> DestinationForecastBundle
}

struct OpenMeteoWeatherForecastService: WeatherForecastServicing {
    private let httpClient: HTTPClient

    init(httpClient: HTTPClient = URLSessionHTTPClient()) {
        self.httpClient = httpClient
    }

    func fetchForecast(for destination: Destination) async throws -> DestinationForecastBundle {
        let endpoint = OpenMeteoEndpoint.forecast(
            latitude: destination.latitude,
            longitude: destination.longitude,
            forecastDays: OpenMeteoRequestParameter.forecastDayCount.intValue
        )
        let data = try await httpClient.data(from: endpoint.url)
        let response: OpenMeteoForecastResponse
        do {
            response = try JSONDecoder().decode(OpenMeteoForecastResponse.self, from: data)
        } catch {
            throw OpenMeteoServiceError.decodingFailed
        }
        do {
            return try OpenMeteoForecastMapper.map(
                response: response,
                destination: destination,
                fetchedAt: Date()
            )
        } catch {
            throw OpenMeteoServiceError.decodingFailed
        }
    }
}
