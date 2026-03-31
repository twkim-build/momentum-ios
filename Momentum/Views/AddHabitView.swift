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
    @Environment(\.modelContext) private var modelContext
    
    @State private var name = ""
    @State private var category = ""
    @State private var frequency = "Daily"
    
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
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines)
        let habit = Habit(
            name: trimmedName,
            category: trimmedCategory.isEmpty ? "General" : trimmedCategory,
            frequency: frequency)
        modelContext.insert(habit)
        dismiss()
    }
}

#Preview {
    AddHabitView()
}
