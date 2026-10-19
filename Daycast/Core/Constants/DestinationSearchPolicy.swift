//
//  DestinationSearchPolicy.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DestinationSearchPolicy {
    case minimumQueryLength
    case debounceMilliseconds
    case recentPreviewLimit
    case forecastCacheLifetimeSeconds

    var intValue: Int {
        switch self {
        case .minimumQueryLength: 2
        case .debounceMilliseconds: 300
        case .recentPreviewLimit: 3
        case .forecastCacheLifetimeSeconds: ForecastCachePolicy.timeToLiveSeconds.intValue
        }
    }

    var debounceDuration: Duration {
        .milliseconds(intValue)
    }
}
