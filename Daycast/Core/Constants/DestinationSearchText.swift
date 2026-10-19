//
//  DestinationSearchText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DestinationSearchText {
    case headline
    case supportingCopy
    case searchPlaceholder
    case recentSectionTitle
    case viewAllHistory
    case emptyHistoryTitle
    case emptyHistoryMessage
    case noResultsTitle
    case noResultsMessage
    case networkErrorTitle
    case networkErrorMessage
    case retryAction
    case preparingForecast
    case historySheetTitle
    case searchLoading
    case clearSearchAccessibilityLabel

    var value: String {
        switch self {
        case .headline: "Where to next?"
        case .supportingCopy: "Find the best days for the activities you love."
        case .searchPlaceholder: "Search city or town"
        case .recentSectionTitle: "Recent destinations"
        case .viewAllHistory: "View all"
        case .emptyHistoryTitle: "No recent destinations"
        case .emptyHistoryMessage: "Search for a city or town to start planning your week."
        case .noResultsTitle: "No destinations found"
        case .noResultsMessage: "Try another spelling or search for a nearby larger city."
        case .networkErrorTitle: "Couldn't search destinations"
        case .networkErrorMessage: "Check your connection and try again."
        case .retryAction: "Retry"
        case .preparingForecast: "Preparing your forecast…"
        case .historySheetTitle: "Recent destinations"
        case .searchLoading: "Searching destinations…"
        case .clearSearchAccessibilityLabel: "Clear search"
        }
    }
}
