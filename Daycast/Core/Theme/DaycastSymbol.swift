//
//  DaycastSymbol.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

enum DaycastSymbol {
    case appMark
    case search
    case clear
    case chevron
    case location

    var systemName: String {
        switch self {
        case .appMark: "sun.horizon.fill"
        case .search: "magnifyingglass"
        case .clear: "xmark.circle.fill"
        case .chevron: "chevron.right"
        case .location: "mappin.and.ellipse"
        }
    }
}
