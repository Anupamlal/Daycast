//
//  ScoreBar.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

struct ScoreBar: View {
    let score: Int?

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.tertiarySystemFill))
                if let score {
                    Capsule()
                        .fill(DaycastAssetColor.accentBlue.color.opacity(0.55))
                        .frame(width: geometry.size.width * CGFloat(score) / 100)
                }
            }
        }
        .frame(height: 6)
        .accessibilityHidden(true)
    }
}
