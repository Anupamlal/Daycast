//
//  DashboardStateView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DashboardStateView: View {
    let state: ActivityOverviewPresentationState
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            DashboardSkeletonView()
        case .error(let showsRetry, _):
            VStack(alignment: .leading, spacing: 12) {
                Text(ActivityOverviewText.loadingErrorTitle.value)
                    .font(.headline)
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                Text(ActivityOverviewText.loadingErrorMessage.value)
                    .font(.subheadline)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
                if showsRetry {
                    Button(ActivityOverviewText.retryAction.value, action: onRetry)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DaycastAssetColor.accentBlue.color)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
        case .loaded, .refreshing:
            EmptyView()
        }
    }
}

struct DashboardSkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value)
                .fill(Color(.secondarySystemBackground))
                .frame(height: 88)

            ForEach(0 ..< 4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 148)
            }
        }
        .redacted(reason: .placeholder)
        .accessibilityLabel(DashboardStateAccessibility.loading.label)
    }
}

enum DashboardStateAccessibility {
    case loading

    var label: String {
        switch self {
        case .loading: "Loading activity forecast"
        }
    }
}
