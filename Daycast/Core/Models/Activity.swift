//
//  Activity.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

/// Dashboard activities in display order (Screen 2).
enum Activity: String, CaseIterable, Identifiable, Sendable, Hashable, Codable {
    case skiing
    case surfing
    case outdoorSightseeing
    case indoorSightseeing

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .skiing: ActivityText.skiingName.value
        case .surfing: ActivityText.surfingName.value
        case .outdoorSightseeing: ActivityText.outdoorSightseeingName.value
        case .indoorSightseeing: ActivityText.indoorSightseeingName.value
        }
    }

    var symbolName: String {
        switch self {
        case .skiing: ActivitySymbol.skiing.systemName
        case .surfing: ActivitySymbol.surfing.systemName
        case .outdoorSightseeing: ActivitySymbol.outdoorSightseeing.systemName
        case .indoorSightseeing: ActivitySymbol.indoorSightseeing.systemName
        }
    }

    var showsSurfingWeatherProxyDisclosure: Bool {
        self == .surfing
    }
}

enum ActivitySymbol {
    case skiing
    case surfing
    case outdoorSightseeing
    case indoorSightseeing

    var systemName: String {
        switch self {
        case .skiing: "snowflake"
        case .surfing: "figure.surfing"
        case .outdoorSightseeing: "binoculars.fill"
        case .indoorSightseeing: "building.2.fill"
        }
    }
}
