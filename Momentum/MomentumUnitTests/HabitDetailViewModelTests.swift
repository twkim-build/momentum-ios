//
//  HabitDetailViewModelTests.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 11.04.26.
//

import Foundation
import Testing
@testable import Momentum

@MainActor
struct HabitDetailViewModelTests {
    @Test
    func loadHabit_success_setsHabitAndClearsError() async {
        let habitID = UUID()
        let repository = MockHabitRepository()
        
        repository.habitDetailToReturn = HabitTestFactory.makeHabitDetailItem(
            id: habitID,
            name: "Workout",
            category: "Health",
            frequency: "Daily",
            currentStreak: 3,
            isCompletedToday: true
        )
        
        let viewModel = HabitDetailViewModel(
            habitID: habitID,
            repository: repository
        )
        
        await viewModel.loadHabit()

        #expect(viewModel.habit?.id == habitID)
        #expect(viewModel.title == "Workout")
        #expect(viewModel.categoryText == "Health")
        #expect(viewModel.frequencyText == "Daily")
        #expect(viewModel.currentStreak == 3)
        #expect(viewModel.isCompletedToday == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func loadHabit_whenMissing_setsNotFoundError() async {
        let repository = MockHabitRepository()
        repository.habitDetailToReturn = nil

        let viewModel = HabitDetailViewModel(
            habitID: UUID(),
            repository: repository
        )

        await viewModel.loadHabit()

        #expect(viewModel.habit == nil)
        #expect(viewModel.errorMessage == "Habit not found.")
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func loadHabit_whenRepositoryThrows_setsLoadError() async {
        let repository = MockHabitRepository()
        repository.errorToThrow = MockRepositoryError.sample

        let viewModel = HabitDetailViewModel(
            habitID: UUID(),
            repository: repository
        )

        await viewModel.loadHabit()

        #expect(viewModel.habit == nil)
        #expect(viewModel.errorMessage == "Failed to load habit.")
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func toggleTodayCompletion_whenNotCompleted_marksDoneToday() async {
        let habitID = UUID()
        let repository = MockHabitRepository()
        repository.habitDetailToReturn = HabitTestFactory.makeHabitDetailItem(
            id: habitID,
            currentStreak: 0,
            isCompletedToday: false,
            completions: []
        )

        let viewModel = HabitDetailViewModel(
            habitID: habitID,
            repository: repository
        )

        await viewModel.loadHabit()
        await viewModel.toggleTodayCompletion()

        #expect(repository.toggleTodayCompletionCallCount == 1)
        #expect(repository.lastToggledHabitID == habitID)
        #expect(viewModel.isCompletedToday == true)
        #expect(viewModel.currentStreak == 1)
        #expect(viewModel.sortedCompletions.count == 1)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func toggleTodayCompletion_whenAlreadyCompleted_undoesToday() async {
        let habitID = UUID()
        let completion = HabitTestFactory.makeCompletionItem(date: Date())

        let repository = MockHabitRepository()
        repository.habitDetailToReturn = HabitTestFactory.makeHabitDetailItem(
            id: habitID,
            currentStreak: 2,
            isCompletedToday: true,
            completions: [completion]
        )

        let viewModel = HabitDetailViewModel(
            habitID: habitID,
            repository: repository
        )

        await viewModel.loadHabit()
        await viewModel.toggleTodayCompletion()

        #expect(repository.toggleTodayCompletionCallCount == 1)
        #expect(viewModel.isCompletedToday == false)
        #expect(viewModel.sortedCompletions.isEmpty)
        #expect(viewModel.currentStreak == 1)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func toggleTodayCompletion_whenRepositoryThrows_setsUpdateError() async {
        let habitID = UUID()
        let repository = MockHabitRepository()
        repository.habitDetailToReturn = HabitTestFactory.makeHabitDetailItem(id: habitID)

        let viewModel = HabitDetailViewModel(
            habitID: habitID,
            repository: repository
        )

        await viewModel.loadHabit()
        repository.errorToThrow = MockRepositoryError.sample

        await viewModel.toggleTodayCompletion()

        #expect(viewModel.errorMessage == "Failed to update habit.")
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func sortedCompletions_returnsCompletionsFromDTO() async {
        let habitID = UUID()
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let completion1 = HabitTestFactory.makeCompletionItem(date: today)
        let completion2 = HabitTestFactory.makeCompletionItem(date: yesterday)

        let repository = MockHabitRepository()
        repository.habitDetailToReturn = HabitTestFactory.makeHabitDetailItem(
            id: habitID,
            currentStreak: 2,
            isCompletedToday: true,
            completions: [completion1, completion2]
        )

        let viewModel = HabitDetailViewModel(
            habitID: habitID,
            repository: repository
        )

        await viewModel.loadHabit()

        #expect(viewModel.sortedCompletions.count == 2)
        #expect(viewModel.currentStreak == 2)
        #expect(viewModel.isCompletedToday == true)
    }
}
