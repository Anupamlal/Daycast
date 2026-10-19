//
//  DaycastBrandHeader.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct DaycastBrandHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: DaycastSymbol.appMark.systemName)
                .font(.title2)
                .foregroundStyle(DaycastAssetColor.accentBlue.color)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(DaycastBrandText.appName.value)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(DaycastAssetColor.primaryNavy.color)

                Text(DaycastBrandText.tagline.value)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(DaycastAssetColor.secondaryText.color)
                    .textCase(.uppercase)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}
