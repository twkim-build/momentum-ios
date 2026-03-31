//
//  HabitListView.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddHabit: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habits) { habit in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.headline)
                        Text(habit.category)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .onDelete(perform: deleteHabits)
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHabit) {
                AddHabitView()
            }
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(habits[index])
        }
    }
}

#Preview {
    HabitListView()
}
