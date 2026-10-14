//
//  ActivityOutlookSummary.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityOutlookSummary: Identifiable, Sendable, Equatable {
    let activity: Activity
    let averageScore: Int?
    let suitableDayCount: Int
    let evaluatedDayCount: Int
    let expectedDayCount: Int
    let reason: String
    let coverageNote: String?

    var id: String { activity.id }

    var suitabilityTier: SuitabilityTier? {
        guard let averageScore else { return nil }
        return SuitabilityTier.from(averageScore: averageScore)
    }
}
