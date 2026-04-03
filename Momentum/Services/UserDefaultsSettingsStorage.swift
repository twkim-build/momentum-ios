//
//  UserDefaultsSettingsStorage.swift
//  Momentum
//
//  Created by taewoo kim on 02.04.26.
//

import Foundation

struct SettingsData: Codable {
    var username: String
    var isNotificationsEnabled: Bool
    var volume: Double
}

protocol SettingsStorage {
    func load() -> SettingsData
    func save(_ settings: SettingsData)
}

final class UserDefaultsSettingsStorage: SettingsStorage {
    private let key = "settings.data"
    private let defaults = UserDefaults.standard

    func load() -> SettingsData {
        guard
            let data = defaults.data(forKey: key),
            let settings = try? JSONDecoder().decode(SettingsData.self, from: data)
        else {
            return SettingsData(
                username: "John",
                isNotificationsEnabled: true,
                volume: 0.5
            )
        }

        return settings
    }

    func save(_ settings: SettingsData) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: key)
    }
}
