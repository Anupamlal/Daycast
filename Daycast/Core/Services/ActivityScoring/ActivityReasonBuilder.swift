//
//  ActivityReasonBuilder.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityReasonBuilder {
    static func reason(for activity: Activity, scoredDays: [ActivityDailyScore]) -> String {
        guard !scoredDays.isEmpty else {
            return ActivityReasonText.insufficientData.value
        }

        let averageTemp = scoredDays.map(\.day.temperatureMaxCelsius).reduce(0, +) / Double(scoredDays.count)
        let averagePrecip = scoredDays.map(\.day.precipitationMillimeters).reduce(0, +) / Double(scoredDays.count)
        let averageWind = scoredDays.map(\.day.windSpeedMaxKilometersPerHour).reduce(0, +) / Double(scoredDays.count)

        switch activity {
        case .skiing:
            if averageTemp <= 2 {
                return ActivityReasonText.skiingCold.value
            }
            if averagePrecip >= 3 {
                return ActivityReasonText.skiingPrecipitation.value
            }
            return ActivityReasonText.skiingMild.value
        case .surfing:
            if averagePrecip >= 4 {
                return ActivityReasonText.surfingRain.value
            }
            if averageWind >= 28 {
                return ActivityReasonText.surfingWindy.value
            }
            return ActivityReasonText.surfingMild.value
        case .outdoorSightseeing:
            if averagePrecip >= 3 {
                return ActivityReasonText.outdoorRain.value
            }
            if averageTemp >= 30 || averageTemp <= 8 {
                return ActivityReasonText.outdoorTemperature.value
            }
            return ActivityReasonText.outdoorComfortable.value
        case .indoorSightseeing:
            if averagePrecip >= 3 || averageTemp >= 30 || averageTemp <= 5 {
                return ActivityReasonText.indoorShelter.value
            }
            return ActivityReasonText.indoorFairOutdoor.value
        }
    }
}

enum ActivityReasonText {
    case insufficientData
    case skiingCold
    case skiingPrecipitation
    case skiingMild
    case surfingRain
    case surfingWindy
    case surfingMild
    case outdoorRain
    case outdoorTemperature
    case outdoorComfortable
    case indoorShelter
    case indoorFairOutdoor

    var value: String {
        switch self {
        case .insufficientData: "Not enough forecast data to judge this week."
        case .skiingCold: "Cool temperatures favor snow-friendly days."
        case .skiingPrecipitation: "Precipitation may help snow, but conditions vary."
        case .skiingMild: "Milder highs limit consistently cold skiing weather."
        case .surfingRain: "Rainy periods reduce this weather-proxy score."
        case .surfingWindy: "Windier days lift the surf proxy, excluding waves."
        case .surfingMild: "Mild temperatures and moderate wind look reasonable."
        case .outdoorRain: "Wetter days are harder for outdoor sightseeing."
        case .outdoorTemperature: "Temperatures look less comfortable for long walks."
        case .outdoorComfortable: "Comfortable temperatures with manageable rain."
        case .indoorShelter: "Rougher outdoor weather favors indoor plans."
        case .indoorFairOutdoor: "Fair outdoor weather means fewer indoor-only days."
        }
    }
}
