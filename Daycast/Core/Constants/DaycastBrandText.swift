//
//  DaycastBrandText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DaycastBrandText {
    case appName
    case tagline

    var value: String {
        switch self {
        case .appName: "Daycast"
        case .tagline: "YOUR WEEK, WELL PLANNED"
        }
    }
}
