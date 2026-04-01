//
//  HabitDetailView.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let habit: Habit
    
    var body: some View {
        List {
            Section("Habit Info") {
                LabeledContent("Name", value: habit.name)
                LabeledContent("Category", value: habit.category)
                LabeledContent("Frequency", value: habit.frequency)
                LabeledContent("Current Streak", value: "\(currentStreak)")
            }
            
            Section("Today") {
                Button(isCompletedToday ? "Undo Today" : "Mark Done Today") {
                    toggleTodayCompletion()
                }
            }
            
            Section("Completion History") {
                if sortedCompletions.isEmpty {
                    Text("No completions yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(sortedCompletions) { completion in
                        Text(completion.date.formatted(date: .abbreviated, time: .omitted))
                    }
                }
            }
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var sortedCompletions: [HabitCompletion] {
        habit.completions.sorted { $0.date > $1.date }
    }
    
    private var isCompletedToday: Bool {
        let calendar = Calendar.current
        return habit.completions.contains { completion in
            calendar.isDateInToday(completion.date)
        }
    }
    
    private var currentStreak: Int {
        StreakCalculator.calculateCurrentStreak(from: habit.completions.map(\.date))
    }
    
    private func toggleTodayCompletion() {
        let calendar = Calendar.current
        
        if let existingCompletion = habit.completions.first(where: { completion in
            calendar.isDateInToday(completion.date)
        }) {
            modelContext.delete(existingCompletion)
        } else {
            let completion = HabitCompletion(date: Date(), habit: habit)
            modelContext.insert(completion)
            habit.completions.append(completion)
        }
    }
}

#Preview {
    HabitDetailView(habit: Habit(name: "Running", category: "Sports", frequency: "Weekday"))
}
