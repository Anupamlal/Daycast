//
//  ActivityRankingViewModel.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class ActivityRankingViewModel {
    let route: ActivityRankingRoute

    var presentationState: ActivityRankingPresentationState = .loading
    var selectedEntry: RankingDayEntry?

    private let forecastRepository: ForecastRepository
    private let rankingBuilder: ActivityRankingBuilder
    private var loadTask: Task<Void, Never>?

    init(
        route: ActivityRankingRoute,
        forecastRepository: ForecastRepository = OpenMeteoForecastRepository(),
        rankingBuilder: ActivityRankingBuilder = ActivityRankingBuilder()
    ) {
        self.route = route
        self.forecastRepository = forecastRepository
        self.rankingBuilder = rankingBuilder
    }

    var navigationTitle: String {
        String(format: ActivityRankingText.navigationTitleFormat.value, route.activity.displayName)
    }

    var destinationSubtitle: String {
        let place = route.destination.subtitle.isEmpty
            ? route.destination.name
            : "\(route.destination.name), \(route.destination.subtitle)"
        return String(format: ActivityRankingText.destinationSubtitleFormat.value, place)
    }

    func onAppear() {
        guard loadTask == nil else { return }
        loadTask = Task { await loadRanking() }
    }

    func refresh() {
        Task { await loadRanking(forceNetwork: true) }
    }

    func retry() {
        presentationState = .loading
        Task { await loadRanking(forceNetwork: true) }
    }

    func selectEntry(_ entry: RankingDayEntry) {
        guard entry.isAvailable else { return }
        selectedEntry = entry
    }

    func dismissDetail() {
        selectedEntry = nil
    }

    private func loadRanking(forceNetwork: Bool = false) async {
        if !forceNetwork, let cached = forecastRepository.cachedForecast(for: route.destination.id) {
            presentRanking(from: cached)
            if forecastRepository.isCacheValid(cached, at: Date()) {
                return
            }
        }

        do {
            let result = try await forecastRepository.loadForecast(
                for: route.destination,
                intent: forceNetwork ? .forceNetwork : .preferCache
            )
            presentRanking(from: result.bundle)
        } catch {
            if let cached = forecastRepository.cachedForecast(for: route.destination.id) {
                presentRanking(from: cached)
            } else {
                presentationState = .error(showsRetry: true)
            }
        }
    }

    private func presentRanking(from bundle: DestinationForecastBundle) {
        let snapshot = rankingBuilder.buildRanking(for: route.activity, bundle: bundle)
        guard snapshot.entries.contains(where: { $0.isAvailable }) else {
            presentationState = .error(showsRetry: true)
            return
        }
        presentationState = .loaded(snapshot)
    }
}
