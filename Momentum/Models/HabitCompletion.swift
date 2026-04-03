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
    var id: UUID = UUID()
    var date: Date
    var habit: Habit?
    
    init(date: Date, habit: Habit? = nil) {
        self.date = date
        self.habit = habit
    }
}
