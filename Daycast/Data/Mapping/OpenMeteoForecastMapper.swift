//
//  OpenMeteoForecastMapper.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum OpenMeteoForecastMapper {
    static func map(
        response: OpenMeteoForecastResponse,
        destination: Destination,
        fetchedAt: Date
    ) throws -> DestinationForecastBundle {
        guard let daily = response.daily else {
            throw ForecastMappingError.missingDailyPayload
        }

        guard !daily.time.isEmpty else {
            throw ForecastMappingError.emptyDailySeries
        }

        let days = daily.forecastDays()
        if days.isEmpty {
            throw ForecastMappingError.inconsistentDailyArrays
        }

        return DestinationForecastBundle(
            destination: destination,
            timezoneIdentifier: response.timezone ?? OpenMeteoRequestParameter.autoTimezone.value,
            days: days,
            fetchedAt: fetchedAt
        )
    }
}
