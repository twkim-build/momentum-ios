//
//  Habit.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var category: String
    var createdAt: Date
    var frequency: String
    
    @Relationship(deleteRule: .cascade)
    var completions: [HabitCompletion] = []
    
    init(id: UUID, name: String, category: String, createdAt: Date, frequency: String, completions: [HabitCompletion]) {
        self.id = id
        self.name = name
        self.category = category
        self.createdAt = createdAt
        self.frequency = frequency
        self.completions = completions
    }
    
    convenience init(name: String, category: String, frequency: String) {
        self.init(id: UUID(), name: name, category: category, createdAt: Date(), frequency: frequency, completions: [])
    }
}
