//
//  HabitRepositoryProtocol.swift
//  Momentum
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation

protocol HabitRepositoryProtocol {
    func fetchHabits() async throws -> [HabitItem]
    func addHabit(name: String, category: String, frequency: String) async throws
    func deleteHabit(id: UUID) async throws
    
    func fetchHabitDetail(id: UUID) async throws -> HabitDetailItem?
    func toggleTodayCompletion(for habitID: UUID) async throws
}
