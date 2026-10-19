//
//  DaycastLayoutMetric.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import CoreGraphics

enum DaycastLayoutMetric {
    case screenHorizontalPadding
    case sectionSpacing
    case rowCornerRadius
    case searchFieldCornerRadius
    case cardCornerRadius
    case rowVerticalPadding
    case brandIconSize

    var value: CGFloat {
        switch self {
        case .screenHorizontalPadding: 20
        case .sectionSpacing: 24
        case .rowCornerRadius: 14
        case .searchFieldCornerRadius: 14
        case .cardCornerRadius: 16
        case .rowVerticalPadding: 14
        case .brandIconSize: 28
        }
    }
}
