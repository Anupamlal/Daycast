//
//  ActivityRankingView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ActivityRankingView: View {
    @State private var viewModel: ActivityRankingViewModel

    init(route: ActivityRankingRoute) {
        _viewModel = State(initialValue: ActivityRankingViewModel(route: route))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        ZStack {
            DaycastAssetColor.canvasWarm.color
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: DaycastLayoutMetric.sectionSpacing.value) {
                    headerSection

                    switch viewModel.presentationState {
                    case .loading:
                        RankingStateView(state: viewModel.presentationState, onRetry: viewModel.retry)
                    case .error:
                        RankingStateView(state: viewModel.presentationState, onRetry: viewModel.retry)
                    case .loaded(let snapshot):
                        rankingList(snapshot: snapshot)
                        Text(ForecastDateFormatting.lastUpdated(snapshot.lastUpdated).formattedValue)
                            .font(.caption)
                            .foregroundStyle(DaycastAssetColor.secondaryText.color)
                    }
                }
                .padding(.horizontal, DaycastLayoutMetric.screenHorizontalPadding.value)
                .padding(.vertical, 20)
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.refresh()
                } label: {
                    Image(systemName: DaycastSymbol.refresh.systemName)
                }
                .accessibilityLabel(ActivityOverviewToolbarAction.refresh.label)
            }
        }
        .onAppear { viewModel.onAppear() }
        .sheet(item: $viewModel.selectedEntry) { entry in
            DailyDetailSheet(entry: entry, activity: viewModel.route.activity)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.destinationSubtitle)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)

            Text(ActivityRankingText.timeWindowLabel.value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(DaycastAssetColor.accentBlue.color)
                .textCase(.uppercase)

            activityDisclaimers
        }
    }

    @ViewBuilder
    private var activityDisclaimers: some View {
        if viewModel.route.activity == .surfing {
            Text(ActivityText.surfingRankingDisclosure.value)
                .font(.caption)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        } else if viewModel.route.activity == .skiing {
            Text(ActivityRankingText.skiingResortCaveat.value)
                .font(.caption)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        }
    }

    private func rankingList(snapshot: ActivityRankingSnapshot) -> some View {
        VStack(spacing: 14) {
            ForEach(snapshot.entries) { entry in
                RankingDayRow(entry: entry) {
                    viewModel.selectEntry(entry)
                }
            }
        }
    }
}
