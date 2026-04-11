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
    func loadHabit_success_setsHabitAndClearError() async {
        let habit = Habit(name: "Workout", category: "Health", frequency: "Daily")
        let repository = MockHabitRepository()
        repository.habitsToReturn = [habit]
        
        let viewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
        await viewModel.loadHabit()
        
        #expect(viewModel.habit?.id == habit.id)
        #expect(viewModel.title == "Workout")
        #expect(viewModel.categoryText == "Health")
        #expect(viewModel.frequencyText == "Daily")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func loadHabit_whenHabitDoesNotExist_setsNotFoundError() async {
        let repository = MockHabitRepository()
        
        let viewModel = HabitDetailViewModel(habitID: UUID(), repository: repository)
        await viewModel.loadHabit()
        
        #expect(viewModel.habit == nil)
        #expect(viewModel.errorMessage == "Habit not found.")
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func loadHabit_whenRepositoryThrows_setsLoadError() async {
        let repository = MockHabitRepository()
        repository.fetchHabitError = MockRepositoryError.sample
        
        let viewModel = HabitDetailViewModel(habitID: UUID(), repository: repository)
        await viewModel.loadHabit()
        
        #expect(viewModel.habit == nil)
        #expect(viewModel.errorMessage == "Failed to load habit.")
        #expect(viewModel.isLoading == false)
    }
    
    @Test
    func toggleTodayCompletion_whenNotCompleted_addsCompletion() async {
        let habit = Habit(name: "Read", category: "Learning", frequency: "Daily")
        let repository = MockHabitRepository()
        repository.habitsToReturn = [habit]
        
        let viewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
        await viewModel.loadHabit()
        await viewModel.toggleTodayCompletion()
        
        #expect(viewModel.habit != nil)
        #expect(viewModel.isCompletedToday == true)
        #expect(viewModel.habit?.completions.count == 1)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func toggleTodayCompletion_whenAlreadyCompleted_removesCompletion() async {
        let habit = Habit(name: "Meditate", category: "Mind", frequency: "Daily")
        let todayCompletion = HabitCompletion(date: Date(), habit: habit)
        habit.completions.append(todayCompletion)
        
        let repository = MockHabitRepository()
        repository.habitsToReturn = [habit]
        
        let viewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
        await viewModel.loadHabit()
        #expect(viewModel.isCompletedToday == true)
        
        await viewModel.toggleTodayCompletion()
        #expect(viewModel.isCompletedToday == false)
        #expect(viewModel.habit?.completions.isEmpty == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func toggleTodayCompletion_whenRepositoryThrows_setsUpdateError() async {
        let habit = Habit(name: "Meditate", category: "Mind", frequency: "Daily")
        let todayCompletion = HabitCompletion(date: Date(), habit: habit)
        habit.completions.append(todayCompletion)
        
        let repository = MockHabitRepository()
        repository.habitsToReturn = [habit]
        
        let viewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
        await viewModel.loadHabit()
        repository.toggleCompletionError = MockRepositoryError.sample
        
        await viewModel.toggleTodayCompletion()
        #expect(viewModel.errorMessage == "Failed to update habit.")
        #expect(viewModel.isUpdating == false)
    }
    
    @Test
    func currentStreak_reflectsLoadedCompletions() async {
        let calendar = Calendar.current
        let habit = Habit(name: "Stretch", category: "Health", frequency: "Daily")
        
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        
        let todayCompletion = HabitCompletion(date: today, habit: habit)
        let yesterdayCompletion = HabitCompletion(date: yesterday, habit: habit)
        let twoDaysAgoCompletion = HabitCompletion(date: twoDaysAgo, habit: habit)
        habit.completions.append(todayCompletion)
        habit.completions.append(yesterdayCompletion)
        habit.completions.append(twoDaysAgoCompletion)
        
        let repository = MockHabitRepository()
        repository.habitsToReturn = [habit]
        
        let viewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
        await viewModel.loadHabit()
        #expect(viewModel.currentStreak == 3)
    }
}
