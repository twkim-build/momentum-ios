//
//  StreakCalculatorTests.swift
//  MomentumUnitTests
//
//  Created by taewoo kim on 03.04.26.
//

import Testing
import Foundation
@testable import Momentum

struct StreakCalculatorTests {
    
    let calendar = Calendar.current
    let referenceDate = ISO8601DateFormatter().date(from: "2026-04-03T12:00:00Z")!
    
    @Test
    func returnsZeroForEmptyEvents() {
        let result = StreakCalculator.calculateCurrentStreak(
            from: [],
            today: referenceDate,
            calendar: calendar
        )
        #expect(result == 0)
    }
    
    @Test
    func returnsThreeForTreeConsecutiveDaysIncludingToday() {
        let day0 = referenceDate
        let day1 = calendar.date(byAdding: .day, value: -1, to: day0)!
        let day2 = calendar.date(byAdding: .day, value: -2, to: day0)!
        let result = StreakCalculator.calculateCurrentStreak(
            from: [day0, day1, day2],
            today: referenceDate,
            calendar: calendar
        )
        #expect(result == 3)
    }
    
    @Test
    func returnsOneWhenThereIsAGapAfterToday() {
        let day0 = referenceDate
        let day2 = calendar.date(byAdding: .day, value: -2, to: day0)!
        let result = StreakCalculator.calculateCurrentStreak(
            from: [day0, day2],
            today: referenceDate,
            calendar: calendar
        )
        #expect(result == 1)
    }
    
    @Test
    func returnsZeroWhenMostRecentDayIsTooOld() {
        let oldDay = calendar.date(byAdding: .day, value: -4, to: referenceDate)!
        
        let result = StreakCalculator.calculateCurrentStreak(
            from: [oldDay],
            today: referenceDate,
            calendar: calendar
        )
        #expect(result == 0)
    }
    
    @Test
    func countsDuplicateEntriesForSameDayOnlyOnce() {
        let sameDayMorning = referenceDate
        let sameDayAfternoon = referenceDate.addingTimeInterval(60 * 60 * 8)
        let result = StreakCalculator.calculateCurrentStreak(
            from: [sameDayMorning, sameDayAfternoon],
            today: referenceDate,
            calendar: calendar
        )
        #expect(result == 1)
    }
}
