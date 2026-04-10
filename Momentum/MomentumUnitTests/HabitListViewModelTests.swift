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
        let mockRepository = MockHabitRepository()
        mockRepository.habitsToReturn = [
            Habit(name: "Workout", category: "Health", frequency: "Daily"),
            Habit(name: "Read", category: "Learning", frequency: "Daily")
        ]
        
        let viewModel = HabitListViewModel(repository: mockRepository)
        await viewModel.loadHabits()
        
        #expect(viewModel.habits.count == 2)
        #expect(viewModel.habits.first?.name == "Workout")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func loadHabits_failure_setsErrorMessage() async {
        let mockRepository = MockHabitRepository()
        mockRepository.errorToThrow = MockError.sample
        
        let viewModel = HabitListViewModel(repository: mockRepository)
        await viewModel.loadHabits()
        
        #expect(viewModel.habits.isEmpty)
        #expect(viewModel.errorMessage == "Failed to load habits.")
        #expect(viewModel.isLoading == false)
    }

    @Test
    func filteredHabits_all_returnsAllHabits() async {
        let mockRepository = MockHabitRepository()
        mockRepository.habitsToReturn = [
            Habit(name: "Workout", category: "Health", frequency: "Daily"),
            Habit(name: "Read", category: "Learning", frequency: "Daily")
        ]
        
        let viewModel = HabitListViewModel(repository: mockRepository)
        await viewModel.loadHabits()
        
        viewModel.selectedFilter = .all
        
        #expect(viewModel.filterHabits().count == 2)
    }
    
    @Test
    func filteredHabits_categoty_returnsOnlyMatchingHabits() async {
        let mockRepository = MockHabitRepository()
        mockRepository.habitsToReturn = [
            Habit(name: "Workout", category: "Health", frequency: "Daily"),
            Habit(name: "Read", category: "Learning", frequency: "Daily"),
            Habit(name: "Run", category: "Health", frequency: "Weekly")
        ]
        
        let viewModel = HabitListViewModel(repository: mockRepository)
        await viewModel.loadHabits()
        
        viewModel.selectedFilter = .category("Health")
        
        #expect(viewModel.filterHabits().count == 2)
        #expect(viewModel.filterHabits().map(\.name) == ["Workout", "Run"])
    }
}
