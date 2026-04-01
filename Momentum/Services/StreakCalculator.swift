//
//  StreakCalculator.swift
//  Momentum
//
//  Created by taewoo kim on 01.04.26.
//

import Foundation

enum StreakCalculator {
    static func calculateCurrentStreak(from dates: [Date]) -> Int {
        let calendar = Calendar.current
        
        let uniqueDays = Set(
            dates.map { calendar.startOfDay(for: $0) }
        )
        let sortedDays = uniqueDays.sorted(by: >)
        
        guard !sortedDays.isEmpty else { return 0 }
        
        let today = calendar.startOfDay(for: Date())
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: today) else { return 0 }
        
        guard sortedDays[0] == today || sortedDays[0] == yesterday else { return 0 }
        
        var streak = 1
        
        for index in 1..<sortedDays.count {
            let previousDay = sortedDays[index - 1]
            let currentDay = sortedDays[index]
            
            guard let expectedDay = calendar.date(byAdding: .day, value: -1, to: previousDay) else {
                break
            }
            
            if calendar.isDate(currentDay, inSameDayAs: expectedDay) {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
    
    
    
}
