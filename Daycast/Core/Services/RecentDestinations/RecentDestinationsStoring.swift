//
//  RecentDestinationsStoring.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol RecentDestinationsStoring: Sendable {
    func loadRecords() -> [RecentDestinationRecord]
    func recordAccess(to destination: Destination, forecastCachedAt: Date?)
    func updateForecastCache(for destinationID: Int, cachedAt: Date)
}

struct UserDefaultsRecentDestinationsStore: RecentDestinationsStoring {
    private let defaults: UserDefaults
    private let storageKey: String

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = RecentDestinationsStorageKey.records.value
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
    }

    func loadRecords() -> [RecentDestinationRecord] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([RecentDestinationRecord].self, from: data)) ?? []
    }

    func recordAccess(to destination: Destination, forecastCachedAt: Date?) {
        var records = loadRecords().filter { $0.destination.id != destination.id }
        let newRecord = RecentDestinationRecord(
            destination: destination,
            lastAccessedAt: Date(),
            forecastCachedAt: forecastCachedAt
        )
        records.insert(newRecord, at: 0)
        save(records)
    }

    func updateForecastCache(for destinationID: Int, cachedAt: Date) {
        var records = loadRecords()
        guard let index = records.firstIndex(where: { $0.destination.id == destinationID }) else { return }
        records[index].forecastCachedAt = cachedAt
        save(records)
    }

    private func save(_ records: [RecentDestinationRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        defaults.set(data, forKey: storageKey)
    }
}

enum RecentDestinationsStorageKey {
    case records

    var value: String {
        switch self {
        case .records: "daycast.recentDestinations"
        }
    }
}
