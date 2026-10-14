//
//  ActivityRankingText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum ActivityRankingText {
    case screenTitle
    case comingSoonMessage

    var value: String {
        switch self {
        case .screenTitle: "Daily ranking"
        case .comingSoonMessage: "Seven-day activity ranking arrives on the next screen."
        }
    }
}
