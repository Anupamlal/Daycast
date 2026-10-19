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
    var isHistorySheetPresented = false

    private let geocodingRepository: GeocodingRepository
    private let recentStore: RecentDestinationsStoring

    private var searchTask: Task<Void, Never>?
    private var activeSearchToken = UUID()

    init(
        geocodingRepository: GeocodingRepository = OpenMeteoGeocodingRepository(),
        recentStore: RecentDestinationsStoring = UserDefaultsRecentDestinationsStore()
    ) {
        self.geocodingRepository = geocodingRepository
        self.recentStore = recentStore
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
        recentRecords = recentStore.loadRecords()
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

    func destinationFromSearchResult(_ destination: Destination) -> Destination {
        clearQuery()
        return destination
    }

    func destinationFromRecentRecord(_ record: RecentDestinationRecord) -> Destination {
        recentStore.recordAccess(to: record.destination, forecastCachedAt: record.forecastCachedAt)
        reloadRecentDestinations()
        return record.destination
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
            let results = try await geocodingRepository.searchDestinations(query: query)
            guard token == activeSearchToken else { return }
            searchResults = results
            searchStatus = results.isEmpty ? .noResults : .idle
        } catch {
            guard token == activeSearchToken else { return }
            searchResults = []
            searchStatus = .failed
        }
    }

    private func cancelSearchWork() {
        searchTask?.cancel()
        searchTask = nil
        activeSearchToken = UUID()
    }
}
