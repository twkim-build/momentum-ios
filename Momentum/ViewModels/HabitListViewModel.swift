//
//  HabitListViewModel.swift
//  Momentum
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation
import Observation

enum HabitFilter: Equatable {
    case all
    case category(String)
}

@MainActor
@Observable
final class HabitListViewModel {
    private let repository: HabitRepositoryProtocol
    
    private(set) var habits: [HabitItem] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var selectedFilter: HabitFilter = .all
    
    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }
    
    var shouldShowEmptyState: Bool {
        !isLoading && habits.isEmpty && errorMessage == nil
    }
    
    func loadHabits() async {
        isLoading = true
        errorMessage = nil
        
        do {
            habits = try await repository.fetchHabits()
        } catch {
            habits = []
            errorMessage = "Failed to load habits."
        }
        
        isLoading = false
    }
    
    func addHabit(name: String, category: String, frequency: String) async -> Bool {
        errorMessage = nil
        
        do {
            try await repository.addHabit(
                name: name,
                category: category,
                frequency: frequency
            )
            await loadHabits()
            return true
        } catch {
            errorMessage = "Failed to save habit."
            return false
        }
    }
    
    func deleteHabits(at offsets: IndexSet) async {
        errorMessage = nil
        
        do {
            for index in offsets {
                let habit = habits[index]
                try await repository.deleteHabit(id: habit.id)
            }
            await loadHabits()
        } catch {
            errorMessage = "Failed to delete habit."
        }
    }
    
    func filterHabits() -> [HabitItem] {
        switch selectedFilter {
        case .all:
            return habits
        case .category(let category):
            return habits.filter{ $0.category == category }
        }
    }

}
