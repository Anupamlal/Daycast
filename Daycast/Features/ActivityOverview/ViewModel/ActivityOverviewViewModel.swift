//
//  ActivityOverviewViewModel.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class ActivityOverviewViewModel {
    let destination: Destination

    var presentationState: ActivityOverviewPresentationState = .loading

    private let forecastService: WeatherForecastServicing
    private let forecastCache: ForecastCacheStoring
    private let recentStore: RecentDestinationsStoring
    private let scoringEngine: ActivityScoringEngine
    private var loadTask: Task<Void, Never>?

    init(
        destination: Destination,
        forecastService: WeatherForecastServicing = OpenMeteoWeatherForecastService(),
        forecastCache: ForecastCacheStoring = UserDefaultsForecastCacheStore(),
        recentStore: RecentDestinationsStoring = UserDefaultsRecentDestinationsStore(),
        scoringEngine: ActivityScoringEngine = ActivityScoringEngine()
    ) {
        self.destination = destination
        self.forecastService = forecastService
        self.forecastCache = forecastCache
        self.recentStore = recentStore
        self.scoringEngine = scoringEngine
    }

    func onAppear() {
        guard loadTask == nil else { return }
        loadTask = Task { await loadInitialForecast() }
    }

    func refresh() {
        Task { await refreshForecast() }
    }

    func retryAfterError() {
        presentationState = .loading
        Task { await loadInitialForecast(forceNetwork: true) }
    }

    private func loadInitialForecast(forceNetwork: Bool = false) async {
        if !forceNetwork, let cached = forecastCache.loadBundle(for: destination.id) {
            let content = buildContent(from: cached, showsStaleNotice: false, showsRefreshFailureNotice: false)
            presentationState = .loaded(content)
            recentStore.recordAccess(to: destination, forecastCachedAt: cached.fetchedAt)

            if cached.isCacheValid(at: Date()) {
                return
            }

            let staleContent = content.updatingNotices(showsStaleNotice: true, showsRefreshFailureNotice: false)
            presentationState = .refreshing(staleContent)
            await refreshForecast(showStaleOnFailure: true)
            return
        }

        presentationState = .loading
        await fetchAndPresent(showRefreshFailureNotice: false, replacingStateOnFailure: true)
    }

    private func refreshForecast(showStaleOnFailure: Bool = false) async {
        if case let .loaded(content) = presentationState {
            presentationState = .refreshing(content)
        } else if case let .refreshing(content) = presentationState {
            presentationState = .refreshing(content)
        }

        await fetchAndPresent(showRefreshFailureNotice: showStaleOnFailure, replacingStateOnFailure: false)
    }

    private func fetchAndPresent(showRefreshFailureNotice: Bool, replacingStateOnFailure: Bool) async {
        do {
            let bundle = try await forecastService.fetchForecast(for: destination)
            forecastCache.saveBundle(bundle)
            recentStore.recordAccess(to: destination, forecastCachedAt: bundle.fetchedAt)
            let content = buildContent(
                from: bundle,
                showsStaleNotice: false,
                showsRefreshFailureNotice: false
            )
            presentationState = .loaded(content)
        } catch {
            let cached = forecastCache.loadBundle(for: destination.id)
            if let cached {
                let content = buildContent(
                    from: cached,
                    showsStaleNotice: false,
                    showsRefreshFailureNotice: showRefreshFailureNotice
                )
                presentationState = .loaded(content)
            } else if replacingStateOnFailure {
                presentationState = .error(showsRetry: true, cachedContent: nil)
            } else if case let .refreshing(previous) = presentationState {
                let failedContent = ActivityDashboardContent(
                    destination: previous.destination,
                    dateRangeText: previous.dateRangeText,
                    firstDaySummary: previous.firstDaySummary,
                    outlooks: previous.outlooks,
                    lastUpdated: previous.lastUpdated,
                    showsStaleNotice: false,
                    showsRefreshFailureNotice: true
                )
                presentationState = .loaded(failedContent)
            }
        }
    }

    private func buildContent(
        from bundle: DestinationForecastBundle,
        showsStaleNotice: Bool,
        showsRefreshFailureNotice: Bool
    ) -> ActivityDashboardContent {
        let days = bundle.days
        let start = days.first?.date ?? ""
        let end = days.last?.date ?? ""
        let dateRange = ForecastDateFormatting.dateRange(
            start: start,
            end: end,
            timeZoneIdentifier: bundle.timezoneIdentifier
        ).formattedValue

        let firstDay = days.first
        let firstDaySummary: ForecastContextSummaryModel? = firstDay.map { day in
            ForecastContextSummaryModel(
                conditionDescription: WeatherConditionText.description(for: day.weatherCode),
                highTemperature: ForecastDateFormatting.temperatureCelsius(day.temperatureMaxCelsius).formattedValue,
                lowTemperature: ForecastDateFormatting.temperatureCelsius(day.temperatureMinCelsius).formattedValue
            )
        }

        let outlooks = scoringEngine.buildOutlooks(for: bundle)

        return ActivityDashboardContent(
            destination: bundle.destination,
            dateRangeText: dateRange,
            firstDaySummary: firstDaySummary,
            outlooks: outlooks,
            lastUpdated: bundle.fetchedAt,
            showsStaleNotice: showsStaleNotice,
            showsRefreshFailureNotice: showsRefreshFailureNotice
        )
    }
}
