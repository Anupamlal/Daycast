//
//  DestinationSearchViewModel.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class DestinationSearchViewModel {
    var query: String = ""
    var searchResults: [Destination] = []
    var recentRecords: [RecentDestinationRecord] = []
    var listMode: DestinationSearchListMode = .recentDestinations
    var searchStatus: DestinationSearchStatus = .idle
    var isPreparingForecast = false
    var isHistorySheetPresented = false

    private let geocodingService: GeocodingServicing?
    private let forecastService: WeatherForecastServicing?
    private let recentStore: RecentDestinationsStoring?

    private var searchTask: Task<Void, Never>?
    private var preparationTask: Task<Void, Never>?
    private var activeSearchToken = UUID()

    init() {
        geocodingService = OpenMeteoGeocodingService()
        forecastService = OpenMeteoWeatherForecastService()
        recentStore = UserDefaultsRecentDestinationsStore()
        reloadRecentDestinations()
    }

    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var meetsMinimumQueryLength: Bool {
        trimmedQuery.count >= DestinationSearchPolicy.minimumQueryLength.intValue
    }

    var previewRecentRecords: [RecentDestinationRecord] {
        Array(recentRecords.prefix(DestinationSearchPolicy.recentPreviewLimit.intValue))
    }

    var shouldShowViewAllHistory: Bool {
        recentRecords.count > DestinationSearchPolicy.recentPreviewLimit.intValue
    }

    var hasRecentHistory: Bool {
        !recentRecords.isEmpty
    }

    func onAppear() {
        reloadRecentDestinations()
    }

    func reloadRecentDestinations() {
        recentRecords = recentStore!.loadRecords()
    }

    func queryDidChange() {
        cancelSearchWork()
        guard meetsMinimumQueryLength else {
            searchResults = []
            searchStatus = .idle
            listMode = .recentDestinations
            return
        }
        listMode = .searchResults
        searchResults = []
        searchStatus = .loading
        scheduleSearch()
    }

    func clearQuery() {
        query = ""
        cancelSearchWork()
        searchResults = []
        searchStatus = .idle
        listMode = .recentDestinations
    }

    func retrySearch() {
        guard meetsMinimumQueryLength else { return }
        searchStatus = .loading
        scheduleSearch()
    }

    func selectSearchResult(_ destination: Destination) {
        prepareForecast(for: destination)
    }

    func selectRecentDestination(_ record: RecentDestinationRecord) {
        let destination = record.destination
        if record.isForecastCacheValid(at: Date()) {
            recentStore!.recordAccess(to: destination, forecastCachedAt: record.forecastCachedAt)
            reloadRecentDestinations()
            return
        }
        prepareForecast(for: destination)
    }

    func presentHistorySheet() {
        isHistorySheetPresented = true
    }

    private func scheduleSearch() {
        let token = UUID()
        activeSearchToken = token
        let querySnapshot = trimmedQuery

        searchTask = Task {
            try? await Task.sleep(for: DestinationSearchPolicy.debounceMilliseconds.debounceDuration)
            guard !Task.isCancelled else { return }
            await performSearch(query: querySnapshot, token: token)
        }
    }

    private func performSearch(query: String, token: UUID) async {
        do {
            let results = try await geocodingService!.searchDestinations(query: query)
            guard token == activeSearchToken else { return }
            searchResults = results
            searchStatus = results.isEmpty ? .noResults : .idle
        } catch {
            guard token == activeSearchToken else { return }
            searchResults = []
            searchStatus = .failed
        }
    }

    private func prepareForecast(for destination: Destination) {
        preparationTask?.cancel()
        isPreparingForecast = true
        clearQuery()

        preparationTask = Task {
            do {
                _ = try await forecastService!.prefetchForecast(for: destination)
                recentStore!.recordAccess(to: destination, forecastCachedAt: Date())
            } catch {
                recentStore!.recordAccess(to: destination, forecastCachedAt: nil)
            }
            reloadRecentDestinations()
            isPreparingForecast = false
        }
    }

    private func cancelSearchWork() {
        searchTask?.cancel()
        searchTask = nil
        activeSearchToken = UUID()
    }
}
