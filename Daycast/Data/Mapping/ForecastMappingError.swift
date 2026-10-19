//
//  ForecastMappingError.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ForecastMappingError: Error, Equatable {
    case missingDailyPayload
    case emptyDailySeries
    case inconsistentDailyArrays
}
