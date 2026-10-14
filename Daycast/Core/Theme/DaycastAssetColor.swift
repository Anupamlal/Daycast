//
//  DaycastAssetColor.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import SwiftUI

enum DaycastAssetColor: String {
    case primaryNavy = "PrimaryNavy"
    case accentBlue = "AccentBlue"
    case canvasWarm = "CanvasWarm"
    case rowBorder = "RowBorder"
    case secondaryText = "SecondaryText"
    case suitableGreen = "SuitableGreen"
    case uncertainAmber = "UncertainAmber"
    case notSuitableRed = "NotSuitableRed"

    var color: Color {
        Color(rawValue)
    }
}
