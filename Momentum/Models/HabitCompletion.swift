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
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
