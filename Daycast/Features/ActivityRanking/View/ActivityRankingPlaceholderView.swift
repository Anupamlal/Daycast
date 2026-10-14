//
//  ActivityRankingPlaceholderView.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ActivityRankingPlaceholderView: View {
    let route: ActivityRankingRoute

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(route.activity.displayName)
                .font(.title2.weight(.bold))
                .foregroundStyle(DaycastAssetColor.primaryNavy.color)

            Text(route.destination.name)
                .font(.subheadline)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)

            Text(ActivityRankingText.comingSoonMessage.value)
                .font(.body)
                .foregroundStyle(DaycastAssetColor.secondaryText.color)

            Spacer()
        }
        .padding(DaycastLayoutMetric.screenHorizontalPadding.value)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(DaycastAssetColor.canvasWarm.color.ignoresSafeArea())
        .navigationTitle(ActivityRankingText.screenTitle.value)
        .navigationBarTitleDisplayMode(.inline)
    }
}
