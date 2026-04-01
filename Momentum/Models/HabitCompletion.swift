//
//  HabitCompletion.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import Foundation
import SwiftData

@Model
final class HabitCompletion {
    var id: UUID
    var date: Date
    var habit: Habit?
    
    init(id: UUID, date: Date, habit: Habit? = nil) {
        self.id = id
        self.date = date
        self.habit = habit
    }
    
    convenience init(date: Date, habit: Habit? = nil) {
        self.init(id: UUID(), date: date, habit: habit)
    }
}
