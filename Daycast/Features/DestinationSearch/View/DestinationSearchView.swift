//
//  DestinationSearchView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationSearchView: View {
    @State private var viewModel = DestinationSearchViewModel()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
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

                if viewModel.isPreparingForecast {
                    forecastPreparationOverlay
                }
            }
            .navigationBarHidden(true)
            .onAppear { viewModel.onAppear() }
            .sheet(isPresented: $viewModel.isHistorySheetPresented) {
                DestinationHistorySheetView(
                    records: viewModel.recentRecords,
                    onSelect: { viewModel.selectRecentDestination($0) }
                )
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
                        viewModel.selectRecentDestination(record)
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
                        viewModel.selectSearchResult(destination)
                    }
                }
            }
        }
    }

    private var shouldShowExplainerCard: Bool {
        dynamicTypeSize <= .accessibility2
    }

    private var forecastPreparationOverlay: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                Text(DestinationSearchText.preparingForecast.value)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding()
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    DestinationSearchView()
}
