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
    
    var addHabitCallCount = 0
    var deleteHabitCallCount = 0
    var fetchHabitsCallCount = 0
    
    var toggleTodayCompletionCallCount = 0
    var lastToggledHabitID: UUID?
    
    var lastAddedHabitName: String?
    var lastAddedHabitCategory: String?
    var lastAddedHabitFrequency: String?
    var deletedHabitIDs: [UUID] = []
    
    func fetchHabits() async throws -> [HabitItem] {
        fetchHabitsCallCount += 1
        
        if let errorToThrow {
            throw errorToThrow
        }
        return habitsToReturn
    }

    func addHabit(name: String, category: String, frequency: String) async throws {
        addHabitCallCount += 1
        
        if let errorToThrow {
            throw errorToThrow
        }
        
        lastAddedHabitName = name
        lastAddedHabitCategory = category
        lastAddedHabitFrequency = frequency
    }
    
    func deleteHabit(id: UUID) async throws {
        deleteHabitCallCount += 1
        
        if let errorToThrow {
            throw errorToThrow
        }
     
        deletedHabitIDs.append(id)
        habitsToReturn.removeAll { $0.id == id }
    }
    
    func fetchHabitDetail(id: UUID) async throws -> HabitDetailItem? {
        if let errorToThrow {
            throw errorToThrow
        }
        return habitDetailToReturn
    }
    
    func toggleTodayCompletion(for habitID: UUID) async throws {
        toggleTodayCompletionCallCount += 1
        lastToggledHabitID = habitID

        if let errorToThrow {
            throw errorToThrow
        }
        
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

