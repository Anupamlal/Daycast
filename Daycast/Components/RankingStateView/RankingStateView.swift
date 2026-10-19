//
//  RankingStateView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct RankingStateView: View {
    let state: ActivityRankingPresentationState
    let onRetry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 72)
                ForEach(0 ..< 4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: DaycastLayoutMetric.cardCornerRadius.value)
                        .fill(Color(.secondarySystemBackground))
                        .frame(height: 88)
                }
            }
            .redacted(reason: .placeholder)
            .accessibilityLabel(DashboardStateAccessibility.loading.label)
        case .error(let showsRetry):
            VStack(alignment: .leading, spacing: 12) {
                Text(ActivityRankingText.loadingErrorTitle.value)
                    .font(.headline)
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                Text(ActivityRankingText.loadingErrorMessage.value)
                    .font(.subheadline)
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
                if showsRetry {
                    Button(ActivityRankingText.retryAction.value, action: onRetry)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(DaycastAssetColor.accentBlue.color)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .loaded:
            EmptyView()
        }
    }
}
