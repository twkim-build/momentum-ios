//
//  HabitMappers.swift
//  Momentum
//
//  Created by taewoo kim on 15.04.26.
//

import Foundation

enum HabitMapper {
    static func toHabitItem(from habit: Habit) -> HabitItem {
        let completionDates = habit.completions.map(\.date)
        return HabitItem(
            id: habit.id,
            name: habit.name,
            category: habit.category,
            frequency: habit.frequency,
            createdAt: habit.createdAt,
            currentStreak: StreakCalculator.calculateCurrentStreak(from: completionDates),
            isCompletedToday: hasCompletionToday(habit.completions)
        )
    }
    
    static func toHabitDetailItem(from habit: Habit) -> HabitDetailItem {
        let sortedCompletions = habit.completions
            .sorted { $0.date > $1.date }
            .map {
                HabitDetailItem.CompletionItem(id: $0.id, date: $0.date)
            }
        let completionDates = habit.completions.map(\.date)
        
        return HabitDetailItem(
            id: habit.id,
            name: habit.name,
            category: habit.category,
            frequency: habit.frequency,
            createdAt: habit.createdAt,
            currentStreak: StreakCalculator.calculateCurrentStreak(from: completionDates),
            isCompletedToday: hasCompletionToday(habit.completions),
            completions: sortedCompletions
        )
    }
    
    private static func hasCompletionToday(_ completions: [HabitCompletion]) -> Bool {
        let calendar = Calendar.current
        return completions.contains { calendar.isDateInToday($0.date) }
    }
}
