//
//  ActivityRankingText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityRankingText {
    case navigationTitleFormat
    case destinationSubtitleFormat
    case timeWindowLabel
    case scoreUnavailable
    case forecastUnavailable
    case scoreFormat
    case rankPrefixFormat
    case loadingErrorTitle
    case loadingErrorMessage
    case retryAction
    case lastUpdatedFormat
    case dailyDetailTitle
    case conditionsSectionTitle
    case whyScoreSectionTitle
    case factorBreakdownTitle
    case skiingResortCaveat
    case surfingDetailDisclaimer
    case safetySectionTitle
    case highLowTemperatureFormat
    case precipitationLabel
    case windLabel
    case sunshineLabel
    case missingFactorValue

    var value: String {
        switch self {
        case .navigationTitleFormat: "%@ ranking"
        case .destinationSubtitleFormat: "Best days in %@"
        case .timeWindowLabel: "Next 7 days"
        case .scoreUnavailable: "—"
        case .forecastUnavailable: "Forecast unavailable"
        case .scoreFormat: "%d / 100"
        case .rankPrefixFormat: "%d · %@"
        case .loadingErrorTitle: "Couldn't load ranking"
        case .loadingErrorMessage: "Check your connection and try again."
        case .retryAction: "Retry"
        case .lastUpdatedFormat: "Updated %@"
        case .dailyDetailTitle: "Day detail"
        case .conditionsSectionTitle: "Conditions"
        case .whyScoreSectionTitle: "Why this score?"
        case .factorBreakdownTitle: "Factor breakdown"
        case .skiingResortCaveat:
            "Forecast snow signals do not confirm resort snow quality, lift operations or open terrain."
        case .surfingDetailDisclaimer:
            "Weather proxy — wave and swell conditions are not available."
        case .safetySectionTitle: "Safety"
        case .highLowTemperatureFormat: "High %@ · Low %@"
        case .precipitationLabel: "Precipitation"
        case .windLabel: "Wind"
        case .sunshineLabel: "Sunshine"
        case .missingFactorValue: "Unavailable"
        }
    }
}

enum ScoreFactorDisplayName {
    case temperature
    case precipitation
    case wind
    case sunshine
    case weatherPattern
    case indoorShelter

    static func from(kind: ScoreFactorKind) -> ScoreFactorDisplayName {
        switch kind {
        case .temperature: .temperature
        case .precipitation: .precipitation
        case .wind: .wind
        case .sunshine: .sunshine
        case .weatherPattern: .weatherPattern
        case .indoorShelter: .indoorShelter
        }
    }

    var value: String {
        switch self {
        case .temperature: "Temperature"
        case .precipitation: "Precipitation"
        case .wind: "Wind"
        case .sunshine: "Sunshine"
        case .weatherPattern: "Weather pattern"
        case .indoorShelter: "Indoor shelter"
        }
    }
}
