//
//  ActivityOverviewText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityOverviewText {
    case dashboardHeadline
    case dashboardSupportingCopy
    case changeDestination
    case suitableDaysFormat
    case outlookScoreLabel
    case lastUpdatedFormat
    case staleDataNotice
    case refreshFailedNotice
    case retryAction
    case partialCoverageFormat
    case loadingErrorTitle
    case loadingErrorMessage
    case firstDayContextFormat
    case suitableLabel
    case uncertainLabel
    case notSuitableLabel
    case averageScoreFormat

    var value: String {
        switch self {
        case .dashboardHeadline: "Plan your week"
        case .dashboardSupportingCopy:
            "Compare how each activity looks across the next seven days."
        case .changeDestination: "Change destination"
        case .suitableDaysFormat: "%d of %d days look suitable"
        case .outlookScoreLabel: "Outlook"
        case .lastUpdatedFormat: "Updated %@"
        case .staleDataNotice: "Showing saved forecast while refreshing…"
        case .refreshFailedNotice: "Couldn't refresh. Showing last saved forecast."
        case .retryAction: "Retry"
        case .partialCoverageFormat: "Based on %d of %d days"
        case .loadingErrorTitle: "Couldn't load forecast"
        case .loadingErrorMessage: "Check your connection and try again."
        case .firstDayContextFormat: "%@ · High %@ · Low %@"
        case .suitableLabel: "Suitable"
        case .uncertainLabel: "Uncertain"
        case .notSuitableLabel: "Not suitable"
        case .averageScoreFormat: "%d"
        }
    }
}
