//
//  EditHabitViewModel.swift
//  Momentum
//
//  Created by taewoo kim on 07.06.26.
//

import Foundation
import Observation

@MainActor
@Observable
final class EditHabitViewModel {
    private let repository: HabitRepositoryProtocol
    private let habitID: UUID

    var name: String
    var category: String
    var frequency: String

    private(set) var isSaving = false
    private(set) var errorMessage: String?

    init(habit: HabitDetailItem, repository: HabitRepositoryProtocol) {
        habitID = habit.id
        name = habit.name
        category = habit.category
        frequency = habit.frequency
        self.repository = repository
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSaving
    }

    func save() async -> Bool {
        guard canSave else { return false }

        isSaving = true
        errorMessage = nil

        do {
            try await repository.updateHabit(
                id: habitID,
                name: name,
                category: category,
                frequency: frequency
            )
            isSaving = false
            return true
        } catch {
            errorMessage = "Failed to update habit."
            isSaving = false
            return false
        }
    }
}
