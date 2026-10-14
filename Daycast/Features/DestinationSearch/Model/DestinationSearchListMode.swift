//
//  DestinationSearchListMode.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DestinationSearchListMode: Equatable {
    case recentDestinations
    case searchResults
}

enum DestinationSearchStatus: Equatable {
    case idle
    case loading
    case noResults
    case failed
}
