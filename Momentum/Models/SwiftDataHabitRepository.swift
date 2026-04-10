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
    
    func deleteHabit(id: UUID) async throws {
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate<Habit> { habit in
                habit.id == id
            }
        )
        
        if let habit = try modelContext.fetch(descriptor).first {
            modelContext.delete(habit)
            try modelContext.save()
        }
    }
    
    func fetchHabit(id: UUID) async throws -> Habit? {
        let descriptor = FetchDescriptor<Habit>(
            predicate: #Predicate<Habit> { habit in
                habit.id == id
            }
        )
        return try modelContext.fetch(descriptor).first
    }
    
    func toggleTodayCompletion(for habitID: UUID) async throws {
        let habitDescriptor = FetchDescriptor<Habit>(
            predicate: #Predicate<Habit> { habit in
                habit.id == habitID
            }
        )
        
        guard let habit = try modelContext.fetch(habitDescriptor).first else {
            return
        }
        
        let calendar = Calendar.current
        let existingCompletion = habit.completions.first(where: { completion in
            calendar.isDateInToday(completion.date)
        })
        
        if let existingCompletion {
            modelContext.delete(existingCompletion)
        } else {
            let completion = HabitCompletion(date: Date(), habit: habit)
            modelContext.insert(completion)
            habit.completions.append(completion)
        }
        
        try modelContext.save()
    }
}
