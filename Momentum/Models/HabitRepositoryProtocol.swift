//
//  HabitRepositoryProtocol.swift
//  Momentum
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation

protocol HabitRepositoryProtocol {
    func fetchHabits() async throws -> [Habit]
}
