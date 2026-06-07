//
//  EditHabitView.swift
//  Momentum
//
//  Created by taewoo kim on 07.06.26.
//

import SwiftUI

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditHabitViewModel

    let onHabitUpdated: (() -> Void)?

    private let frequencyOptions = ["Daily", "Weekdays", "Weekly"]

    init(
        viewModel: EditHabitViewModel,
        onHabitUpdated: (() -> Void)? = nil
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onHabitUpdated = onHabitUpdated
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Info") {
                    TextField("Name", text: $viewModel.name)
                    TextField("Category", text: $viewModel.category)

                    Picker("Frequency", selection: $viewModel.frequency) {
                        ForEach(frequencyOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Section{
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(viewModel.isSaving)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            let didSave = await viewModel.save()
                            if didSave {
                                onHabitUpdated?()
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
}
