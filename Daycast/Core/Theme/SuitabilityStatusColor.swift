//
//  SuitabilityStatusColor.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

enum SuitabilityStatusColor {
    case suitable
    case uncertain
    case notSuitable

    init(tier: SuitabilityTier) {
        switch tier {
        case .suitable: self = .suitable
        case .uncertain: self = .uncertain
        case .notSuitable: self = .notSuitable
        }
    }

    var color: Color {
        switch self {
        case .suitable: DaycastAssetColor.suitableGreen.color
        case .uncertain: DaycastAssetColor.uncertainAmber.color
        case .notSuitable: DaycastAssetColor.notSuitableRed.color
        }
    }
}
