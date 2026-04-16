//
//  HabitListView.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var repository: SwiftDataHabitRepository?
    @State private var isShowingAddHabit: Bool = false
    @State private var viewModel: HabitListViewModel?
    
    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    contentView(viewModel)
                } else {
                    ProgressView("Preparing habits...")
                }
            }
            .navigationTitle("Habits")
            .toolbar {
                if viewModel != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingAddHabit = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingAddHabit) {
                if let viewModel {
                    AddHabitView(viewModel: viewModel)
                }
            }
        }
        .task {
            if repository == nil {
                repository = SwiftDataHabitRepository(modelContext: modelContext)
            }
            
            if viewModel == nil, let repository {
                viewModel = HabitListViewModel(repository: repository)
            }
            
            if let viewModel, viewModel.habits.isEmpty, !viewModel.isLoading {
                await viewModel.loadHabits()
            }
        }
    }
    
    @ViewBuilder
    private func contentView(_ viewModel: HabitListViewModel) -> some View {
        if viewModel.isLoading && viewModel.habits.isEmpty {
            ProgressView("Loading habits...")
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                "Somthing went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
        } else if viewModel.shouldShowEmptyState {
            ContentUnavailableView(
                "No Habits Yet",
                systemImage: "checklist",
                description: Text("Tap + to create your first habit.")
            )
        } else {
            List {
                ForEach(viewModel.habits) { habit in
                    NavigationLink {
                        if let repository {
                            let detailViewModel = HabitDetailViewModel(habitID: habit.id, repository: repository)
                            HabitDetailView(viewModel: detailViewModel)
                                .onDisappear {
                                    Task {
                                        await viewModel.loadHabits()
                                    }
                                }
                        }
                    } label: {
                        HabitRowView(habit: habit)
                    }
                }
                .onDelete { offsets in
                    Task {
                        await viewModel.deleteHabits(at: offsets)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                if let errorMessage = viewModel.errorMessage, !viewModel.habits.isEmpty {
                    Text(errorMessage)
                        .font(.footnote)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 8)
                }
            }
            .refreshable {
                await viewModel.loadHabits()
            }
        }
    }
}

#Preview {
    HabitListView()
}
