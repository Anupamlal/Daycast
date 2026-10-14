//
//  OpenMeteoForecastResponse.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct OpenMeteoForecastResponse: Decodable, Sendable {
    let daily: OpenMeteoDailyForecast?
    let timezone: String?
}

struct OpenMeteoDailyForecast: Decodable, Sendable {
    let time: [String]
    let weatherCode: [Int]?
    let temperatureMax: [Double]?
    let temperatureMin: [Double]?
    let precipitationSum: [Double]?
    let windSpeedMax: [Double]?
    let sunshineDuration: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case precipitationSum = "precipitation_sum"
        case windSpeedMax = "wind_speed_10m_max"
        case sunshineDuration = "sunshine_duration"
    }

    func forecastDays() -> [ForecastDay] {
        time.enumerated().compactMap { index, date in
            guard
                let weatherCode = weatherCode?[safe: index],
                let tempMax = temperatureMax?[safe: index],
                let tempMin = temperatureMin?[safe: index],
                let precipitation = precipitationSum?[safe: index],
                let wind = windSpeedMax?[safe: index]
            else {
                return nil
            }
            return ForecastDay(
                date: date,
                weatherCode: weatherCode,
                temperatureMaxCelsius: tempMax,
                temperatureMinCelsius: tempMin,
                precipitationMillimeters: precipitation,
                windSpeedMaxKilometersPerHour: wind,
                sunshineDurationSeconds: sunshineDuration?[safe: index]
            )
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
