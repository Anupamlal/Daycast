//
//  OpenMeteoDailyVariable.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum OpenMeteoDailyVariable: String, CaseIterable {
    case weatherCode = "weather_code"
    case temperatureMax = "temperature_2m_max"
    case temperatureMin = "temperature_2m_min"
    case precipitationSum = "precipitation_sum"
    case windSpeedMax = "wind_speed_10m_max"
    case sunshineDuration = "sunshine_duration"

    static var combinedRequestValue: String {
        allCases.map(\.rawValue).joined(separator: ",")
    }
}
