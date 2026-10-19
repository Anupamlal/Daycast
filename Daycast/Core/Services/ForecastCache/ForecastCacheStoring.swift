//
//  ForecastCacheStoring.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

protocol ForecastCacheStoring: Sendable {
    func loadBundle(for destinationID: Int) -> DestinationForecastBundle?
    func saveBundle(_ bundle: DestinationForecastBundle)
}

struct UserDefaultsForecastCacheStore: ForecastCacheStoring {
    private let defaults: UserDefaults
    private let storageKey: String

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = ForecastCacheStorageKey.bundles.value
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
    }

    func loadBundle(for destinationID: Int) -> DestinationForecastBundle? {
        guard let data = defaults.data(forKey: storageKey) else { return nil }
        let bundles = (try? JSONDecoder().decode([DestinationForecastBundle].self, from: data)) ?? []
        return bundles.first { $0.destination.id == destinationID }
    }

    func saveBundle(_ bundle: DestinationForecastBundle) {
        var bundles = loadAllBundles().filter { $0.destination.id != bundle.destination.id }
        bundles.insert(bundle, at: 0)
        guard let data = try? JSONEncoder().encode(bundles) else { return }
        defaults.set(data, forKey: storageKey)
    }

    private func loadAllBundles() -> [DestinationForecastBundle] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([DestinationForecastBundle].self, from: data)) ?? []
    }
}

enum ForecastCacheStorageKey {
    case bundles

    var value: String {
        switch self {
        case .bundles: "daycast.forecastBundles"
        }
    }
}
