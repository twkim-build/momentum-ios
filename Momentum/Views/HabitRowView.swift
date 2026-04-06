//
//  HabitRowView.swift
//  Momentum
//
//  Created by taewoo kim on 06.04.26.
//

import SwiftUI

struct HabitRowView: View {
    let habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(habit.name)
                    .font(.headline)
                Spacer()
                
                if isCompletedToday {
                    Text("Done Today")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.15))
                        .clipShape(Capsule())
                    
                }
            }
            
            HStack {
                Text(habit.category)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Streak: \(currentStreak)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var isCompletedToday: Bool {
        let calendar = Calendar.current
        return habit.completions.contains {
            calendar.isDateInToday($0.date)
        }
    }
    
    private var currentStreak: Int {
        StreakCalculator.calculateCurrentStreak(from: habit.completions.map(\.date))
    }
}
