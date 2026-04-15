//
//  MockHabitRepository.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation
@testable import Momentum

@MainActor
final class MockHabitRepository: HabitRepositoryProtocol {
    var habitsToReturn: [HabitItem] = []
    var habitDetailToReturn: HabitDetailItem?
    var errorToThrow: Error?
    
    var toggleTodayCompletionCallCount = 0
    var lastToggledHabitID: UUID?
    
    func fetchHabits() async throws -> [HabitItem] {
        if let errorToThrow {
            throw errorToThrow
        }
        return habitsToReturn
    }

    func addHabit(name: String, category: String, frequency: String) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        
        #if false
        let habit = Habit(name: name, category: category, frequency: frequency)
        habits.append(habit)
        habitsToReturn.append(HabitMapper.toHabitItem(from: habit))
        #endif
    }
    
    func deleteHabit(id: UUID) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        
        #if false
        habits.removeAll { $0.id == id }
        habitsToReturn.removeAll { $0.id == id }
        #endif
    }
    
    func fetchHabitDetail(id: UUID) async throws -> HabitDetailItem? {
        if let errorToThrow {
            throw errorToThrow
        }
        return habitDetailToReturn
        
        #if false
        guard let habit = habits.first(where: { $0.id == id }) else {
            return nil
        }
        return HabitMapper.toHabitDetailItem(from: habit)
        #endif
    }
    
    func toggleTodayCompletion(for habitID: UUID) async throws {
        if let errorToThrow {
            throw errorToThrow
        }
        
        toggleTodayCompletionCallCount += 1
        lastToggledHabitID = habitID
        
        guard let current = habitDetailToReturn else { return }
        
        let calendar = Calendar.current
        
        if current.isCompletedToday {
            let filteredCompletions = current.completions.filter {
                !calendar.isDateInToday($0.date)
            }

            habitDetailToReturn = HabitDetailItem(
                id: current.id,
                name: current.name,
                category: current.category,
                frequency: current.frequency,
                createdAt: current.createdAt,
                currentStreak: max(0, current.currentStreak - 1),
                isCompletedToday: false,
                completions: filteredCompletions
            )
        } else {
            let newCompletion = HabitDetailItem.CompletionItem(
                id: UUID(),
                date: Date()
            )

            habitDetailToReturn = HabitDetailItem(
                id: current.id,
                name: current.name,
                category: current.category,
                frequency: current.frequency,
                createdAt: current.createdAt,
                currentStreak: current.currentStreak + 1,
                isCompletedToday: true,
                completions: [newCompletion] + current.completions
            )
        }
    }
}

enum MockRepositoryError: Error {
    case sample
}

