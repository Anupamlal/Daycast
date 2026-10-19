//
//  SevereWeatherDetector.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum SevereWeatherDetector {
    static func cautionMessage(for day: ForecastDay) -> String? {
        if SevereWeatherCode.from(weatherCode: day.weatherCode) != nil {
            return SevereWeatherText.thunderstormCaution.value
        }
        if day.windSpeedMaxKilometersPerHour >= 70 {
            return SevereWeatherText.highWindCaution.value
        }
        return nil
    }
}

enum SevereWeatherCode: Int {
    case thunderstorm = 95
    case thunderstormWithHail = 96
    case heavyThunderstormWithHail = 99

    static func from(weatherCode: Int) -> SevereWeatherCode? {
        SevereWeatherCode(rawValue: weatherCode)
    }
}

enum SevereWeatherText {
    case thunderstormCaution
    case highWindCaution

    var value: String {
        switch self {
        case .thunderstormCaution: "Thunderstorm risk — consider safety before outdoor plans."
        case .highWindCaution: "Very strong wind — use extra caution outdoors."
        }
    }
}
