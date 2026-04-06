//
//  SwiftDataHabitRepository.swift
//  Momentum
//
//  Created by taewoo kim on 06.04.26.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataHabitRepository: HabitRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchHabits() async throws -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    func addHabit(name: String, category: String, frequency: String) async throws {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        let habit = Habit(
            name: trimmedName,
            category: trimmedCategory.isEmpty ? "General" : trimmedCategory,
            frequency: frequency
        )
        modelContext.insert(habit)
        try modelContext.save()
    }
    
    func deleteHabit(_ habit: Habit) async throws {
        modelContext.delete(habit)
        try modelContext.save()
    }
}
