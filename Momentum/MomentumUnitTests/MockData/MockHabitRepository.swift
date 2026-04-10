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
    func addHabit(name: String, category: String, frequency: String) async throws {
        habitsToReturn.append(Habit(name: name, category: category, frequency: frequency))
    }
    
    func deleteHabit(id: UUID) async throws {
        if let index = habitsToReturn.firstIndex(where: { id == $0.id }) {
            habitsToReturn.remove(at: index)
        }
    }
    
    var habitsToReturn: [Habit] = []
    var errorToThrow: Error?
    
    func fetchHabits() async throws -> [Habit] {
       if let error = errorToThrow {
            throw error
        }
        return habitsToReturn
    }
}

enum MockError: Error {
    case sample
}

