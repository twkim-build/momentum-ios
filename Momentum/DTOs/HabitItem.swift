//
//  HabitItem.swift
//  Momentum
//
//  Created by taewoo kim on 15.04.26.
//

import Foundation

struct HabitItem: Identifiable, Sendable, Equatable {
    let id: UUID
    let name: String
    let category: String
    let frequency: String
    let createdAt: Date
    let currentStreak: Int
    let isCompletedToday: Bool
}
