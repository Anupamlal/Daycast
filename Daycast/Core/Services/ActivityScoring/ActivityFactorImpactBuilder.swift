//
//  ActivityFactorImpactBuilder.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityFactorImpactBuilder {
    static func factors(for activity: Activity, day: ForecastDay) -> [ScoreFactorImpact] {
        var impacts: [ScoreFactorImpact] = []

        impacts.append(temperatureImpact(for: activity, day: day))
        impacts.append(precipitationImpact(day: day))
        impacts.append(windImpact(for: activity, day: day))

        if let sunshine = day.sunshineDurationSeconds {
            impacts.append(sunshineImpact(seconds: sunshine))
        }

        impacts.append(weatherPatternImpact(day: day))

        if activity == .indoorSightseeing {
            impacts.append(indoorShelterImpact(day: day))
        }

        return impacts
    }

    private static func temperatureImpact(for activity: Activity, day: ForecastDay) -> ScoreFactorImpact {
        let value = ForecastDateFormatting.temperatureCelsius(day.temperatureMaxCelsius).formattedValue
        let polarity: FactorImpactPolarity
        let description: String

        switch activity {
        case .skiing:
            if day.temperatureMaxCelsius <= 2 {
                polarity = .positive
                description = ScoreFactorImpactText.temperatureColdHelped.value
            } else if day.temperatureMaxCelsius >= 8 {
                polarity = .negative
                description = ScoreFactorImpactText.temperatureTooMild.value
            } else {
                polarity = .neutral
                description = ScoreFactorImpactText.temperatureModerate.value
            }
        case .surfing, .outdoorSightseeing:
            if day.temperatureMaxCelsius >= 18, day.temperatureMaxCelsius <= 28 {
                polarity = .positive
                description = ScoreFactorImpactText.temperatureComfortable.value
            } else {
                polarity = .negative
                description = ScoreFactorImpactText.temperatureLessComfortable.value
            }
        case .indoorSightseeing:
            if day.temperatureMaxCelsius >= 30 || day.temperatureMaxCelsius <= 5 {
                polarity = .positive
                description = ScoreFactorImpactText.temperatureIndoorFavored.value
            } else {
                polarity = .neutral
                description = ScoreFactorImpactText.temperatureModerate.value
            }
        }

        return ScoreFactorImpact(
            factor: .temperature,
            observedValue: value,
            polarity: polarity,
            impactDescription: description
        )
    }

    private static func precipitationImpact(day: ForecastDay) -> ScoreFactorImpact {
        let value = String(format: ScoreFactorImpactText.precipitationFormat.value, day.precipitationMillimeters)
        let polarity: FactorImpactPolarity
        let description: String

        if day.precipitationMillimeters < 1 {
            polarity = .positive
            description = ScoreFactorImpactText.lowRainHelped.value
        } else if day.precipitationMillimeters >= 4 {
            polarity = .negative
            description = ScoreFactorImpactText.heavyRainReduced.value
        } else {
            polarity = .neutral
            description = ScoreFactorImpactText.moderateRain.value
        }

        return ScoreFactorImpact(
            factor: .precipitation,
            observedValue: value,
            polarity: polarity,
            impactDescription: description
        )
    }

    private static func windImpact(for activity: Activity, day: ForecastDay) -> ScoreFactorImpact {
        let value = String(format: ScoreFactorImpactText.windFormat.value, day.windSpeedMaxKilometersPerHour)
        let polarity: FactorImpactPolarity
        let description: String

        switch activity {
        case .surfing:
            if day.windSpeedMaxKilometersPerHour >= 15, day.windSpeedMaxKilometersPerHour <= 30 {
                polarity = .positive
                description = ScoreFactorImpactText.windSurfProxy.value
            } else if day.windSpeedMaxKilometersPerHour > 40 {
                polarity = .negative
                description = ScoreFactorImpactText.windTooStrong.value
            } else {
                polarity = .neutral
                description = ScoreFactorImpactText.windModerate.value
            }
        default:
            if day.windSpeedMaxKilometersPerHour > 35 {
                polarity = .negative
                description = ScoreFactorImpactText.windTooStrong.value
            } else if day.windSpeedMaxKilometersPerHour < 20 {
                polarity = .positive
                description = ScoreFactorImpactText.lightWindHelped.value
            } else {
                polarity = .neutral
                description = ScoreFactorImpactText.windModerate.value
            }
        }

        return ScoreFactorImpact(
            factor: .wind,
            observedValue: value,
            polarity: polarity,
            impactDescription: description
        )
    }

    private static func sunshineImpact(seconds: Double) -> ScoreFactorImpact {
        let hours = seconds / 3600
        let value = String(format: ScoreFactorImpactText.sunshineHoursFormat.value, hours)
        let polarity: FactorImpactPolarity = hours >= 4 ? .positive : .neutral
        let description = hours >= 4
            ? ScoreFactorImpactText.sunshineHelped.value
            : ScoreFactorImpactText.sunshineLimited.value

        return ScoreFactorImpact(
            factor: .sunshine,
            observedValue: value,
            polarity: polarity,
            impactDescription: description
        )
    }

    private static func weatherPatternImpact(day: ForecastDay) -> ScoreFactorImpact {
        let category = WeatherCodeCategory.from(code: day.weatherCode)
        let value = WeatherConditionText.description(for: day.weatherCode)
        let polarity: FactorImpactPolarity
        let description: String

        switch category {
        case .clear:
            polarity = .positive
            description = ScoreFactorImpactText.clearSkiesHelped.value
        case .rain:
            polarity = .negative
            description = ScoreFactorImpactText.rainPatternReduced.value
        case .snow:
            polarity = .neutral
            description = ScoreFactorImpactText.snowSignalsCautious.value
        case .other:
            polarity = .neutral
            description = ScoreFactorImpactText.mixedPattern.value
        }

        return ScoreFactorImpact(
            factor: .weatherPattern,
            observedValue: value,
            polarity: polarity,
            impactDescription: description
        )
    }

    private static func indoorShelterImpact(day: ForecastDay) -> ScoreFactorImpact {
        let outdoorStress = day.precipitationMillimeters + max(0, day.windSpeedMaxKilometersPerHour - 25) * 0.2
        let polarity: FactorImpactPolarity = outdoorStress >= 5 ? .positive : .neutral
        let description = outdoorStress >= 5
            ? ScoreFactorImpactText.indoorShelterHelped.value
            : ScoreFactorImpactText.indoorNeutral.value

        return ScoreFactorImpact(
            factor: .indoorShelter,
            observedValue: ScoreFactorImpactText.indoorObserved.value,
            polarity: polarity,
            impactDescription: description
        )
    }
}

enum ScoreFactorImpactText {
    case temperatureColdHelped
    case temperatureTooMild
    case temperatureModerate
    case temperatureComfortable
    case temperatureLessComfortable
    case temperatureIndoorFavored
    case precipitationFormat
    case lowRainHelped
    case heavyRainReduced
    case moderateRain
    case windFormat
    case windSurfProxy
    case windTooStrong
    case windModerate
    case lightWindHelped
    case sunshineHoursFormat
    case sunshineHelped
    case sunshineLimited
    case clearSkiesHelped
    case rainPatternReduced
    case snowSignalsCautious
    case mixedPattern
    case indoorShelterHelped
    case indoorNeutral
    case indoorObserved

    var value: String {
        switch self {
        case .temperatureColdHelped: "Cold temperatures helped the skiing heuristic"
        case .temperatureTooMild: "Mild temperatures reduced the skiing score"
        case .temperatureModerate: "Temperatures were moderate"
        case .temperatureComfortable: "Comfortable temperatures helped"
        case .temperatureLessComfortable: "Temperatures were less comfortable"
        case .temperatureIndoorFavored: "Extreme temperatures favored indoor plans"
        case .precipitationFormat: "%.1f mm"
        case .lowRainHelped: "Low rain chance helped"
        case .heavyRainReduced: "Frequent showers reduced the score"
        case .moderateRain: "Some rain was manageable"
        case .windFormat: "%.0f km/h max"
        case .windSurfProxy: "Moderate wind supports the surf weather proxy"
        case .windTooStrong: "Strong wind reduced the score"
        case .windModerate: "Wind was moderate"
        case .lightWindHelped: "Light wind helped"
        case .sunshineHoursFormat: "%.1f h sunshine"
        case .sunshineHelped: "Good sunshine helped outdoor comfort"
        case .sunshineLimited: "Limited sunshine"
        case .clearSkiesHelped: "Clearer skies helped"
        case .rainPatternReduced: "Rain in the forecast reduced the score"
        case .snowSignalsCautious: "Snow signals do not confirm resort conditions"
        case .mixedPattern: "Mixed weather pattern"
        case .indoorShelterHelped: "Poor outdoor weather favored indoor sightseeing"
        case .indoorNeutral: "Outdoor weather was fair"
        case .indoorObserved: "Shelter factor"
        }
    }
}
