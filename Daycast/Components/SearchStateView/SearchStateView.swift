//
//  SearchStateView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct SearchStateView: View {
    let status: DestinationSearchStatus
    let onRetry: () -> Void

    var body: some View {
        switch status {
        case .idle:
            EmptyView()
        case .loading:
            HStack(spacing: 10) {
                ProgressView()
                Text(DestinationSearchText.searchLoading.value)
                    .font(.subheadline)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .combine)
        case .noResults:
            VStack(alignment: .leading, spacing: 6) {
                Text(DestinationSearchText.noResultsTitle.value)
                    .font(.headline)
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                Text(DestinationSearchText.noResultsMessage.value)
                    .font(.subheadline)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .failed:
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(DestinationSearchText.networkErrorTitle.value)
                        .font(.headline)
                        .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                    Text(DestinationSearchText.networkErrorMessage.value)
                        .font(.subheadline)
                        .foregroundStyle(DaycastAssetColor.secondaryText.color)
                }

                Button(DestinationSearchText.retryAction.value, action: onRetry)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DaycastAssetColor.accentBlue.color)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
