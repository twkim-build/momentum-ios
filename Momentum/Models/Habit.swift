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
    var id: UUID = UUID()
    var name: String
    var category: String
    var createdAt: Date
    var frequency: String
    
    @Relationship(deleteRule: .cascade, inverse: \HabitCompletion.habit)
    var completions: [HabitCompletion] = []
    
    init(name: String, category: String, createdAt: Date, frequency: String) {
        self.name = name
        self.category = category
        self.createdAt = createdAt
        self.frequency = frequency
    }
    
    convenience init(name: String, category: String, frequency: String) {
        self.init(name: name, category: category, createdAt: Date(), frequency: frequency)
    }
}
