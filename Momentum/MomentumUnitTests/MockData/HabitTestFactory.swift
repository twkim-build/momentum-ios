//
//  HabitTestFactory.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 15.04.26.
//

import Foundation
@testable import Momentum

enum HabitTestFactory {
    static func makeHabitItem(
        id: UUID = UUID(),
        name: String = "Workout",
        category: String = "Health",
        frequency: String = "Daily",
        createdAt: Date = Date(),
        currentStreak: Int = 0,
        isCompletedToday: Bool = false
    ) -> HabitItem {
        HabitItem(
            id: id,
            name: name,
            category: category,
            frequency: frequency,
            createdAt: createdAt,
            currentStreak: currentStreak,
            isCompletedToday: isCompletedToday
        )
    }

    static func makeHabitDetailItem(
        id: UUID = UUID(),
        name: String = "Workout",
        category: String = "Health",
        frequency: String = "Daily",
        createdAt: Date = Date(),
        currentStreak: Int = 0,
        isCompletedToday: Bool = false,
        completions: [HabitDetailItem.CompletionItem] = []
    ) -> HabitDetailItem {
        HabitDetailItem(
            id: id,
            name: name,
            category: category,
            frequency: frequency,
            createdAt: createdAt,
            currentStreak: currentStreak,
            isCompletedToday: isCompletedToday,
            completions: completions
        )
    }

    static func makeCompletionItem(
        id: UUID = UUID(),
        date: Date = Date()
    ) -> HabitDetailItem.CompletionItem {
        HabitDetailItem.CompletionItem(
            id: id,
            date: date
        )
    }
}
