//
//  DayPlan.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

/// A single day the user is considering for an activity.
struct DayPlan: Identifiable, Sendable {
    let id: UUID
    let date: Date
    var activity: Activity?

    init(id: UUID = UUID(), date: Date, activity: Activity? = nil) {
        self.id = id
        self.date = date
        self.activity = activity
    }
}
