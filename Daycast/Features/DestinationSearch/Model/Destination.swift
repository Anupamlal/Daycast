//
//  Destination.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct Destination: Identifiable, Equatable, Codable, Sendable, Hashable {
    let id: Int
    let name: String
    let region: String?
    let country: String?
    let latitude: Double
    let longitude: Double

    var subtitle: String {
        let parts = [region, country].compactMap { part -> String? in
            guard let part, !part.isEmpty else { return nil }
            return part
        }
        return parts.joined(separator: ", ")
    }
}

struct RecentDestinationRecord: Identifiable, Equatable, Codable, Sendable {
    let destination: Destination
    var lastAccessedAt: Date
    var forecastCachedAt: Date?

    var id: Int { destination.id }

    func isForecastCacheValid(at referenceDate: Date) -> Bool {
        guard let forecastCachedAt else { return false }
        let lifetime = TimeInterval(DestinationSearchPolicy.forecastCacheLifetimeSeconds.intValue)
        return referenceDate.timeIntervalSince(forecastCachedAt) < lifetime
    }
}
