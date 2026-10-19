//
//  ForecastDateFormatting.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ForecastDateFormatting {
    case dateRange(start: String, end: String, timeZoneIdentifier: String)
    case lastUpdated(Date)
    case temperatureCelsius(Double)

    var formattedValue: String {
        switch self {
        case let .dateRange(start, end, timeZoneIdentifier):
            let formatter = ForecastDateFormatting.makeDayFormatter(timeZoneIdentifier: timeZoneIdentifier)
            guard
                let startDate = ForecastDateFormatting.isoDayFormatter.date(from: start),
                let endDate = ForecastDateFormatting.isoDayFormatter.date(from: end)
            else {
                return "\(start) – \(end)"
            }
            return "\(formatter.string(from: startDate)) – \(formatter.string(from: endDate))"
        case let .lastUpdated(date):
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return String(format: ActivityOverviewText.lastUpdatedFormat.value, formatter.string(from: date))
        case let .temperatureCelsius(value):
            return String(format: "%.0f°", value)
        }
    }

    private static let isoDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static func makeDayFormatter(timeZoneIdentifier: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? .current
        return formatter
    }
}

enum WeatherConditionText {
    static func description(for code: Int) -> String {
        switch WeatherCodeCategory.from(code: code) {
        case .clear: WeatherConditionDescription.clear.value
        case .rain: WeatherConditionDescription.rain.value
        case .snow: WeatherConditionDescription.snow.value
        case .other: WeatherConditionDescription.mixed.value
        }
    }
}

enum WeatherConditionDescription {
    case clear
    case rain
    case snow
    case mixed

    var value: String {
        switch self {
        case .clear: "Mostly clear"
        case .rain: "Rain likely"
        case .snow: "Snow possible"
        case .mixed: "Mixed conditions"
        }
    }
}
