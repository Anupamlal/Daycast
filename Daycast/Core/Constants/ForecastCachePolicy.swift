//
//  ForecastCachePolicy.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ForecastCachePolicy {
    case timeToLiveSeconds

    var intValue: Int {
        switch self {
        case .timeToLiveSeconds: 21_600
        }
    }

    var timeInterval: TimeInterval {
        TimeInterval(intValue)
    }
}
