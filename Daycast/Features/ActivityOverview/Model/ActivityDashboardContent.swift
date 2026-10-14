//
//  ActivityDashboardContent.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityDashboardContent: Sendable, Equatable {
    let destination: Destination
    let dateRangeText: String
    let firstDaySummary: ForecastContextSummaryModel?
    let outlooks: [ActivityOutlookSummary]
    let lastUpdated: Date
    let showsStaleNotice: Bool
    let showsRefreshFailureNotice: Bool

    func updatingNotices(showsStaleNotice: Bool, showsRefreshFailureNotice: Bool) -> ActivityDashboardContent {
        ActivityDashboardContent(
            destination: destination,
            dateRangeText: dateRangeText,
            firstDaySummary: firstDaySummary,
            outlooks: outlooks,
            lastUpdated: lastUpdated,
            showsStaleNotice: showsStaleNotice,
            showsRefreshFailureNotice: showsRefreshFailureNotice
        )
    }
}

struct ForecastContextSummaryModel: Sendable, Equatable {
    let conditionDescription: String
    let highTemperature: String
    let lowTemperature: String
}

enum ActivityOverviewPresentationState: Equatable {
    case loading
    case loaded(ActivityDashboardContent)
    case refreshing(ActivityDashboardContent)
    case error(showsRetry: Bool, cachedContent: ActivityDashboardContent?)
}
