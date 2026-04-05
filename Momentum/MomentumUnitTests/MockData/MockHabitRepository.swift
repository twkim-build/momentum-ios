//
//  MockHabitRepository.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation
@testable import Momentum

final class MockHabitRepository: HabitRepositoryProtocol {
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

