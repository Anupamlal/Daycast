//
//  ActivityText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityText {
    case skiingName
    case surfingName
    case outdoorSightseeingName
    case indoorSightseeingName
    case surfingProxyDisclosure

    var value: String {
        switch self {
        case .skiingName: "Skiing"
        case .surfingName: "Surfing"
        case .outdoorSightseeingName: "Outdoor Sightseeing"
        case .indoorSightseeingName: "Indoor Sightseeing"
        case .surfingProxyDisclosure: "Weather proxy — wave conditions unavailable"
        }
    }
}
