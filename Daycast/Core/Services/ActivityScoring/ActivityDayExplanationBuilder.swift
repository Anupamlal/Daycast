//
//  ActivityDayExplanationBuilder.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityDayExplanationBuilder {
    static func summary(for activity: Activity, day: ForecastDay, score: Int) -> String {
        let precip = day.precipitationMillimeters
        let wind = day.windSpeedMaxKilometersPerHour
        let temp = day.temperatureMaxCelsius

        switch activity {
        case .outdoorSightseeing:
            if precip < 1, wind < 25 {
                return ActivityDayExplanationText.outdoorMildLowRain.value
            }
            if precip >= 3 {
                return ActivityDayExplanationText.outdoorHigherRain.value
            }
            if wind >= 30 {
                return ActivityDayExplanationText.outdoorStrongerWind.value
            }
            return ActivityDayExplanationText.outdoorSomeCloud.value
        case .skiing:
            if temp <= 0, precip > 0 {
                return ActivityDayExplanationText.skiingColdSnowSignals.value
            }
            if temp > 5 {
                return ActivityDayExplanationText.skiingMildLimiting.value
            }
            return ActivityDayExplanationText.skiingCoolOutlook.value
        case .surfing:
            if precip >= 4 {
                return ActivityDayExplanationText.surfingRainReduces.value
            }
            if wind >= 35 {
                return ActivityDayExplanationText.surfingWindyMixed.value
            }
            return ActivityDayExplanationText.surfingComfortableProxy.value
        case .indoorSightseeing:
            if precip >= 3 || temp >= 30 || temp <= 5 {
                return ActivityDayExplanationText.indoorShelterFavored.value
            }
            return ActivityDayExplanationText.indoorFairOutdoor.value
        }
    }
}

enum ActivityDayExplanationText {
    case outdoorMildLowRain
    case outdoorSomeCloud
    case outdoorHigherRain
    case outdoorStrongerWind
    case skiingColdSnowSignals
    case skiingMildLimiting
    case skiingCoolOutlook
    case surfingRainReduces
    case surfingWindyMixed
    case surfingComfortableProxy
    case indoorShelterFavored
    case indoorFairOutdoor

    var value: String {
        switch self {
        case .outdoorMildLowRain: "Mild, low rain chance, light wind"
        case .outdoorSomeCloud: "Comfortable temperatures; some cloud"
        case .outdoorHigherRain: "Higher rain chance reduces the score"
        case .outdoorStrongerWind: "Cooler with stronger wind"
        case .skiingColdSnowSignals: "Cold with precipitation signals; resort conditions vary"
        case .skiingMildLimiting: "Mild highs limit consistently cold skiing weather"
        case .skiingCoolOutlook: "Cool outlook; snow quality not confirmed"
        case .surfingRainReduces: "Rain reduces this weather-proxy score"
        case .surfingWindyMixed: "Gusty wind; waves not evaluated"
        case .surfingComfortableProxy: "Comfortable temperatures for the weather proxy"
        case .indoorShelterFavored: "Rougher outdoor weather favors indoor plans"
        case .indoorFairOutdoor: "Fair outdoor weather means fewer indoor-only days"
        }
    }
}
