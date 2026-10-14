//
//  DestinationHeader.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DestinationHeader: View {
    let destination: Destination
    let dateRangeText: String
    let onChangeDestination: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(destination.name)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(DaycastAssetColor.primaryNavy.color)
                        .accessibilityAddTraits(.isHeader)

                    if !destination.subtitle.isEmpty {
                        Text(destination.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(DaycastAssetColor.secondaryText.color)
                    }

                    Text(dateRangeText)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(DaycastAssetColor.accentBlue.color)
                }

                Spacer(minLength: 8)

                Button(ActivityOverviewText.changeDestination.value, action: onChangeDestination)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(DaycastAssetColor.accentBlue.color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
