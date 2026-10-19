//
//  ActivityOverviewView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ActivityOverviewView: View {
    let destination: Destination
    let onChangeDestination: () -> Void
    let onSelectActivity: (ActivityRankingRoute) -> Void

    @State private var viewModel: ActivityOverviewViewModel

    init(
        destination: Destination,
        onChangeDestination: @escaping () -> Void,
        onSelectActivity: @escaping (ActivityRankingRoute) -> Void
    ) {
        self.destination = destination
        self.onChangeDestination = onChangeDestination
        self.onSelectActivity = onSelectActivity
        _viewModel = State(initialValue: ActivityOverviewViewModel(destination: destination))
    }

    var body: some View {
        ZStack {
            DaycastAssetColor.canvasWarm.color
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: DaycastLayoutMetric.sectionSpacing.value) {
                    statusBanner

                    switch viewModel.presentationState {
                    case .loading:
                        DashboardStateView(state: viewModel.presentationState, onRetry: viewModel.retryAfterError)
                    case .error:
                        DashboardStateView(state: viewModel.presentationState, onRetry: viewModel.retryAfterError)
                    case .loaded(let content), .refreshing(let content):
                        dashboardBody(content: content)
                    }
                }
                .padding(.horizontal, DaycastLayoutMetric.screenHorizontalPadding.value)
                .padding(.vertical, 20)
            }

            if case .refreshing = viewModel.presentationState {
                VStack {
                    HStack {
                        Spacer()
                        ProgressView()
                            .padding(10)
                            .background(.ultraThinMaterial, in: Capsule())
                            .padding()
                    }
                    Spacer()
                }
                .accessibilityLabel(DashboardStateAccessibility.loading.label)
            }
        }
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
    }

    @ViewBuilder
    private func dashboardBody(content: ActivityDashboardContent) -> some View {
        DestinationHeader(
            destination: content.destination,
            dateRangeText: content.dateRangeText,
            onChangeDestination: onChangeDestination
        )

        if let firstDaySummary = content.firstDaySummary {
            ForecastContextSummary(model: firstDaySummary)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text(ActivityOverviewText.dashboardHeadline.value)
                .font(.title2.weight(.bold))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                .accessibilityAddTraits(.isHeader)

            Text(ActivityOverviewText.dashboardSupportingCopy.value)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        }

        VStack(spacing: 14) {
            ForEach(content.outlooks) { outlook in
                ActivityOverviewCard(outlook: outlook) {
                    onSelectActivity(
                        ActivityRankingRoute(destination: content.destination, activity: outlook.activity)
                    )
                }
            }
        }

        Text(ForecastDateFormatting.lastUpdated(content.lastUpdated).formattedValue)
            .font(.caption)
            .foregroundStyle(DaycastAssetColor.secondaryText.color)
    }

    @ViewBuilder
    private var statusBanner: some View {
        switch viewModel.presentationState {
        case .loaded(let content), .refreshing(let content):
            if content.showsStaleNotice {
                noticeBanner(ActivityOverviewText.staleDataNotice.value)
            } else if content.showsRefreshFailureNotice {
                noticeBanner(ActivityOverviewText.refreshFailedNotice.value)
            }
        default:
            EmptyView()
        }
    }

    private func noticeBanner(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(DaycastAssetColor.primaryNavy.color)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.rowCornerRadius.value, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
    }
}

enum ActivityOverviewToolbarAction {
    case refresh

    var label: String {
        switch self {
        case .refresh: "Refresh forecast"
        }
    }
}
