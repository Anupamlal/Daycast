//
//  DestinationSearchView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationSearchView: View {
    @State private var viewModel = DestinationSearchViewModel()
    @State private var navigationPath = NavigationPath()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                DaycastAssetColor.canvasWarm.color
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: DaycastLayoutMetric.sectionSpacing.value) {
                        DaycastBrandHeader()

                        heroSection

                        DestinationSearchField(
                            text: $viewModel.query,
                            onTextChange: { viewModel.queryDidChange() },
                            onClear: { viewModel.clearQuery() }
                        )

                        listSection

                        if shouldShowExplainerCard {
                            DaycastExplainerCard()
                        }
                    }
                    .padding(.horizontal, DaycastLayoutMetric.screenHorizontalPadding.value)
                    .padding(.vertical, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear { viewModel.onAppear() }
            .sheet(isPresented: $viewModel.isHistorySheetPresented) {
                DestinationHistorySheetView(
                    records: viewModel.recentRecords,
                    onSelect: { record in
                        navigationPath.append(viewModel.destinationFromRecentRecord(record))
                    }
                )
            }
            .navigationDestination(for: Destination.self) { destination in
                ActivityOverviewView(
                    destination: destination,
                    onChangeDestination: { navigationPath = NavigationPath() },
                    onSelectActivity: { navigationPath.append($0) }
                )
            }
            .navigationDestination(for: ActivityRankingRoute.self) { route in
                ActivityRankingView(route: route)
            }
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(DestinationSearchText.headline.value)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                .accessibilityAddTraits(.isHeader)

            Text(DestinationSearchText.supportingCopy.value)
                .font(.body)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)
        }
    }

    @ViewBuilder
    private var listSection: some View {
        switch viewModel.listMode {
        case .recentDestinations:
            recentDestinationsSection
        case .searchResults:
            searchResultsSection
        }
    }

    private var recentDestinationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if viewModel.hasRecentHistory {
                HStack {
                    Text(DestinationSearchText.recentSectionTitle.value)
                        .font(.headline)
                        .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                    Spacer()

                    if viewModel.shouldShowViewAllHistory {
                        Button(DestinationSearchText.viewAllHistory.value) {
                            viewModel.presentHistorySheet()
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DaycastAssetColor.accentBlue.color)
                    }
                }

                ForEach(viewModel.previewRecentRecords) { record in
                    RecentDestinationRow(record: record) {
                        navigationPath.append(viewModel.destinationFromRecentRecord(record))
                    }
                }
            } else {
                EmptyHistoryView()
            }
        }
    }

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SearchStateView(status: viewModel.searchStatus, onRetry: { viewModel.retrySearch() })

            if viewModel.searchStatus == .idle {
                ForEach(viewModel.searchResults) { destination in
                    DestinationSearchResultRow(destination: destination) {
                        navigationPath.append(viewModel.destinationFromSearchResult(destination))
                    }
                }
            }
        }
    }

    private var shouldShowExplainerCard: Bool {
        dynamicTypeSize <= .accessibility2
    }
}

#Preview {
    DestinationSearchView()
}
