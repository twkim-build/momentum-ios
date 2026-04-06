//
//  AddHabitView.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    
    let viewModel: HabitListViewModel
    
    @State private var name = ""
    @State private var category = ""
    @State private var frequency = "Daily"
    @State private var isSaving = false

    let frequencyOptions: [String] = ["Daily", "Weekdays", "Weekly"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Habit Info") {
                    TextField("Name", text: $name)
                    TextField("Category", text: $category)
                    
                    Picker("Frequency", selection: $frequency) {
                        ForEach(frequencyOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isSaving)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveHabit()
                        }
                    }
                    .disabled(isSaveDisabled)
                }
            }
        }
    }
    
    private var isSaveDisabled: Bool {
        isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveHabit() async {
        isSaving = true
        let didSave = await viewModel.addHabit(
            name: name,
            category: category,
            frequency: frequency
        )
        isSaving = false
        
        if didSave {
            dismiss()
        }
    }
}

#Preview {
//    AddHabitView()
}
