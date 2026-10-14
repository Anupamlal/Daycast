//
//  DaycastExplainerText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DaycastExplainerText {
    case title
    case body

    var value: String {
        switch self {
        case .title: "Plan around the weather"
        case .body:
            "Daycast compares skiing, surfing, and sightseeing conditions across the next seven days."
        }
    }
}
