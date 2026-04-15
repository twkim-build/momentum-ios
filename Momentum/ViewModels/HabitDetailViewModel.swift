//
//  HabitDetailViewModel.swift
//  Momentum
//
//  Created by taewoo kim on 10.04.26.
//

import Foundation
import Observation

@MainActor
@Observable
final class HabitDetailViewModel {
    private let repository: HabitRepositoryProtocol
    private let habitID: UUID
    
    private(set) var habit: HabitDetailItem?
    private(set) var isLoading = false
    private(set) var isUpdating = false
    private(set) var errorMessage: String?
    
    init(habitID: UUID, repository: HabitRepositoryProtocol) {
        self.habitID = habitID
        self.repository = repository
    }

    var title: String {
        habit?.name ?? "Habit"
    }
    
    var categoryText: String {
        habit?.category ?? "-"
    }
    
    var frequencyText: String {
        habit?.frequency ?? "-"
    }
    
    var sortedCompletions: [HabitDetailItem.CompletionItem] {
        return habit?.completions ?? []
    }
    
    var isCompletedToday: Bool {
        habit?.isCompletedToday ?? false
    }
    
    var currentStreak: Int {
        habit?.currentStreak ?? 0
    }
    
    func loadHabit() async {
        isLoading = true
        errorMessage = nil
        
        do {
            habit = try await repository.fetchHabitDetail(id: habitID)
            if habit == nil {
                errorMessage = "Habit not found."
            }
        } catch {
            errorMessage = "Failed to load habit."
        }
        
        isLoading = false
    }
    
    func toggleTodayCompletion() async {
        guard habit != nil else { return }
        
        isUpdating = true
        errorMessage = nil
     
        do {
            try await repository.toggleTodayCompletion(for: habitID)
            habit = try await repository.fetchHabitDetail(id: habitID)
        } catch {
            errorMessage = "Failed to update habit."
        }
        
        isUpdating = false
    }
    
}
