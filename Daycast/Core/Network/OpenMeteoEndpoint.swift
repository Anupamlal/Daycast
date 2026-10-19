//
//  OpenMeteoEndpoint.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum OpenMeteoEndpoint {
    case geocodingSearch(query: String, resultCount: Int)
    case forecast(latitude: Double, longitude: Double, forecastDays: Int)

    var url: URL {
        switch self {
        case let .geocodingSearch(query, resultCount):
            var components = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")!
            components.queryItems = [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "count", value: String(resultCount)),
                URLQueryItem(name: "language", value: OpenMeteoRequestParameter.language.value),
                URLQueryItem(name: "format", value: OpenMeteoRequestParameter.responseFormat.value),
            ]
            return components.url!

        case let .forecast(latitude, longitude, forecastDays):
            var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
            components.queryItems = [
                URLQueryItem(name: "latitude", value: String(latitude)),
                URLQueryItem(name: "longitude", value: String(longitude)),
                URLQueryItem(name: "forecast_days", value: String(forecastDays)),
                URLQueryItem(name: "timezone", value: OpenMeteoRequestParameter.autoTimezone.value),
                URLQueryItem(name: "daily", value: OpenMeteoDailyVariable.combinedRequestValue),
            ]
            return components.url!
        }
    }
}

enum OpenMeteoRequestParameter {
    case language
    case responseFormat
    case autoTimezone
    case geocodingResultCount
    case forecastDayCount

    var value: String {
        switch self {
        case .language: "en"
        case .responseFormat: "json"
        case .autoTimezone: "auto"
        case .geocodingResultCount: "10"
        case .forecastDayCount: "7"
        }
    }

    var intValue: Int {
        switch self {
        case .forecastDayCount: 7
        case .geocodingResultCount: 10
        default: 0
        }
    }
}
