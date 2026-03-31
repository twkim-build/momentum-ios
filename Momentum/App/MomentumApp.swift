//
//  MomentumApp.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import SwiftUI
import SwiftData

@main
struct MomentumApp: App {
    #if false
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    #endif
    
    var body: some Scene {
        WindowGroup {
            HabitListView()
        }
        .modelContainer(for: [Habit.self, HabitCompletion.self])
    }
}
