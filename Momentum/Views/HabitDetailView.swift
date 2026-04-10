//
//  HabitDetailView.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @State private var viewModel: HabitDetailViewModel
    
    init(viewModel: HabitDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        List {
            if viewModel.isLoading && viewModel.habit == nil {
                ProgressView("Loading habit...")
            } else if let errorMessage = viewModel.errorMessage, viewModel.habit == nil {
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "exclamationmark.circle",
                    description: Text(errorMessage)
                )
            } else if viewModel.habit != nil {
                Section("Habit Info") {
                    LabeledContent("Name", value: viewModel.title)
                    LabeledContent("Category", value: viewModel.categoryText)
                    LabeledContent("Frequency", value: viewModel.frequencyText)
                    LabeledContent("Current Streak", value: "\(viewModel.currentStreak)")
                }
                
                Section("Today") {
                    Button(viewModel.isCompletedToday ? "Undo Today" : "Mark Done Today") {
                        Task {
                            await viewModel.toggleTodayCompletion()
                        }
                    }
                    .disabled(viewModel.isUpdating)
                    
                    if viewModel.isUpdating {
                        ProgressView()
                    }
                }
                
                Section("Completion History") {
                    if viewModel.sortedCompletions.isEmpty {
                        Text("No completions yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.sortedCompletions) { completion in
                            Text(completion.date.formatted(date: .abbreviated, time: .omitted))
                        }
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.habit == nil && !viewModel.isLoading {
                await viewModel.loadHabit()
            }
        }
        .refreshable {
            await viewModel.loadHabit()
        }
    }
}

#Preview {
}
