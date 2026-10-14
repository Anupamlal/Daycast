//
//  Activity.swift
//  Daycast
//

import Foundation

/// Outdoor or location-based activity the user wants to plan for.
enum Activity: String, CaseIterable, Identifiable, Sendable {
    case hiking
    case beach
    case cycling
    case photography
    case picnic

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hiking: "Hiking"
        case .beach: "Beach"
        case .cycling: "Cycling"
        case .photography: "Photography"
        case .picnic: "Picnic"
        }
    }
}
