//
//  DailyDetailText.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

enum DailyDetailText {
    case closeAction

    var value: String {
        switch self {
        case .closeAction: "Close"
        }
    }
}
