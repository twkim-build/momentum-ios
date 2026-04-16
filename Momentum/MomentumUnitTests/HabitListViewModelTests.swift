//
//  HabitListViewModelTests.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 05.04.26.
//

import Foundation
import Testing
@testable import Momentum

@MainActor
struct HabitListViewModelTests {

    @Test
    func loadHabits_success_updatesHabits() async {
        let repository = MockHabitRepository()
        repository.habitsToReturn = [
            HabitTestFactory.makeHabitItem(name: "Workout", category: "Health", frequency: "Daily", currentStreak: 3, isCompletedToday: true),
            HabitTestFactory.makeHabitItem(name: "Read", category: "Learning", frequency: "Daily", currentStreak: 1, isCompletedToday: false),
        ]
        
        let viewModel = HabitListViewModel(repository: repository)
        await viewModel.loadHabits()
        
        #expect(repository.fetchHabitsCallCount == 1)
        #expect(viewModel.habits.count == 2)
        #expect(viewModel.habits[0].name == "Workout")
        #expect(viewModel.habits[1].name == "Read")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.shouldShowEmptyState == false)
    }
    
    @Test
    func loadHabits_failure_setsErrorMessageAndClearsHabits() async {
        let repository = MockHabitRepository()
        repository.errorToThrow = MockRepositoryError.sample
        
        let viewModel = HabitListViewModel(repository: repository)
        await viewModel.loadHabits()
        
        #expect(repository.fetchHabitsCallCount == 1)
        #expect(viewModel.errorMessage == "Failed to load habits.")
        #expect(viewModel.isLoading == false)
        #expect(viewModel.shouldShowEmptyState == false)
    }

    @Test
    func loadHabits_whenRepositoryReturnsEmpty_keepsEmptyStateTrue() async {
        let repository = MockHabitRepository()
        repository.habitsToReturn = []
        
        let viewModel = HabitListViewModel(repository: repository)
        await viewModel.loadHabits()
        
        #expect(viewModel.habits.isEmpty == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.shouldShowEmptyState == true)
    }
    
    @Test
    func addHabit_success_callsRepositoryAndReloadsHabits() async {
        let repository = MockHabitRepository()
        let addedHabit = HabitTestFactory.makeHabitItem(name: "Meditate", category: "Mind", frequency: "Daily")
        
        repository.habitsToReturn = [addedHabit]
        
        let viewModel = HabitListViewModel(repository: repository)
        let didSave = await viewModel.addHabit(name: "Meditate", category: "Mind", frequency: "Daily")
        
        #expect(didSave == true)
        #expect(repository.addHabitCallCount == 1)
        #expect(repository.fetchHabitsCallCount == 1)
        #expect(repository.lastAddedHabitName == "Meditate")
        #expect(repository.lastAddedHabitCategory == "Mind")
        #expect(repository.lastAddedHabitFrequency == "Daily")
        #expect(viewModel.habits.count == 1)
        #expect(viewModel.habits.first?.name == "Meditate")
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test
    func addHabit_failure_setErrorMessage() async {
        let repository = MockHabitRepository()
        repository.errorToThrow = MockRepositoryError.sample
        
        let viewModel = HabitListViewModel(repository: repository)
        let didSave = await viewModel.addHabit(name: "Read", category: "Learning", frequency: "Dailt")
        
        #expect(didSave == false)
        #expect(repository.addHabitCallCount == 1)
        #expect(viewModel.errorMessage == "Failed to save habit.")
    }
    
    @Test
    func deleteHabits_success_deleteSelectedIDsAndReloads() async {
        let firstID = UUID()
        let secondID = UUID()
        
        let repository = MockHabitRepository()
        repository.habitsToReturn = [
            HabitTestFactory.makeHabitItem(id: firstID, name: "Workout"),
            HabitTestFactory.makeHabitItem(id: secondID, name: "Read")
        ]
        
        let viewModel = HabitListViewModel(repository: repository)
        await viewModel.loadHabits()
        await viewModel.deleteHabits(at: IndexSet(integer: 0))
        
        #expect(repository.deleteHabitCallCount == 1)
        #expect(repository.deletedHabitIDs == [firstID])
        #expect(repository.fetchHabitsCallCount == 2)
        #expect(viewModel.habits.count == 1)
        #expect(viewModel.habits.first?.id == secondID)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test
    func deleteHabits_failure_setsErrorMessage() async {
        let firstID = UUID()
        
        let repository = MockHabitRepository()
        repository.habitsToReturn = [
            HabitTestFactory.makeHabitItem(id: firstID, name: "Workout")
        ]
        
        let viewModel = HabitListViewModel(repository: repository)
        await viewModel.loadHabits()
        
        repository.errorToThrow = MockRepositoryError.sample
        await viewModel.deleteHabits(at: IndexSet(integer: 0))
        
        #expect(repository.deleteHabitCallCount == 1)
        #expect(viewModel.errorMessage == "Failed to delete habit.")
    }
}
