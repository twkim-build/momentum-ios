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
    var habitsToReturn: [Habit] = []
    var fetchHabitError: Error?
    var toggleCompletionError: Error?
    
    func fetchHabits() async throws -> [Habit] {
        if let fetchHabitError {
            throw fetchHabitError
        }
        return habitsToReturn
    }

    func addHabit(name: String, category: String, frequency: String) async throws {
        let habit = Habit(name: name, category: category, frequency: frequency)
        habitsToReturn.append(habit)
    }
    
    func deleteHabit(id: UUID) async throws {
        habitsToReturn.removeAll { $0.id == id }
    }
    
    func fetchHabit(id: UUID) async throws -> Habit? {
        if let fetchHabitError {
            throw fetchHabitError
        }
        return habitsToReturn.first { $0.id == id }
    }
    
    func toggleTodayCompletion(for habitID: UUID) async throws {
        if let toggleCompletionError {
            throw toggleCompletionError
        }
        
        guard let habit = habitsToReturn.first(where: { $0.id == habitID }) else {
            return
        }
        
        let calendar = Calendar.current
        
        if let existingIndex = habit.completions.firstIndex(where: { calendar.isDateInToday($0.date)}) {
            habit.completions.remove(at: existingIndex)
        } else {
            let completion = HabitCompletion(date: Date(), habit: habit)
            habit.completions.append(completion)
        }
    }
}

enum MockRepositoryError: Error {
    case sample
}

