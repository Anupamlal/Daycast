//
//  ActivityRankingBuilder.swift
//  Daycast
//
//  Created by Anupam Kumar Lal on 14/10/26.
//

import Foundation

struct ActivityRankingBuilder: Sendable {
    private let evaluateDay: @Sendable (ForecastDay, Activity) -> ActivityDayEvaluation?

    init(scoringEngine: ActivityScoringEngine = ActivityScoringEngine()) {
        self.evaluateDay = { day, activity in
            scoringEngine.evaluateDay(day: day, activity: activity)
        }
    }

    init(evaluateDay: @escaping @Sendable (ForecastDay, Activity) -> ActivityDayEvaluation?) {
        self.evaluateDay = evaluateDay
    }

    func buildRanking(
        for activity: Activity,
        bundle: DestinationForecastBundle,
        evaluateDay: (@Sendable (ForecastDay, Activity) -> ActivityDayEvaluation?)? = nil
    ) -> ActivityRankingSnapshot {
        let timezoneIdentifier = bundle.timezoneIdentifier
        let evaluate = evaluateDay ?? self.evaluateDay

        let scoredItems: [(ForecastDay, ActivityDayEvaluation)] = bundle.days.compactMap { day in
            guard let evaluation = evaluate(day, activity) else { return nil }
            return (day, evaluation)
        }

        let sortedScored = scoredItems.sorted { lhs, rhs in
            if lhs.1.score != rhs.1.score {
                return lhs.1.score > rhs.1.score
            }
            return lhs.0.date < rhs.0.date
        }

        var entries: [RankingDayEntry] = []
        for (index, item) in sortedScored.enumerated() {
            entries.append(
                RankingDayEntry(
                    day: item.0,
                    rank: index + 1,
                    evaluation: item.1,
                    timezoneIdentifier: timezoneIdentifier,
                    isTopRanked: index == 0
                )
            )
        }

        let unavailableDays = bundle.days.filter { day in
            !scoredItems.contains(where: { $0.0.date == day.date })
        }
        .sorted { $0.date < $1.date }

        for day in unavailableDays {
            entries.append(
                RankingDayEntry(
                    day: day,
                    rank: nil,
                    evaluation: nil,
                    timezoneIdentifier: timezoneIdentifier,
                    isTopRanked: false
                )
            )
        }

        return ActivityRankingSnapshot(
            destination: bundle.destination,
            activity: activity,
            timezoneIdentifier: timezoneIdentifier,
            entries: entries,
            lastUpdated: bundle.fetchedAt
        )
    }
}
