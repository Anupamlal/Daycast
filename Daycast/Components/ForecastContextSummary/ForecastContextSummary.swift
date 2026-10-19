//
//  ForecastContextSummary.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ForecastContextSummary: View {
    let model: ForecastContextSummaryModel

    var body: some View {
        Text(
            String(
                format: ActivityOverviewText.firstDayContextFormat.value,
                model.conditionDescription,
                model.highTemperature,
                model.lowTemperature
            )
        )
        .font(.footnote)
        .foregroundStyle(DaycastAssetColor.secondaryText.color)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
