//
//  SettingsViewModel.swift
//  Momentum
//
//  Created by taewoo kim on 02.04.26.
//

import Foundation
import Observation

@Observable
class SettingsViewModel {
    var username: String {
        didSet { save() }
    }

    var isNotificationsEnabled: Bool {
        didSet { save() }
    }

    var volume: Double {
        didSet { save() }
    }

    private let storage: SettingsStorage

    init(storage: SettingsStorage = UserDefaultsSettingsStorage()) {
        self.storage = storage

        let data = storage.load()
        self.username = data.username
        self.isNotificationsEnabled = data.isNotificationsEnabled
        self.volume = data.volume
    }

    private func save() {
        let data = SettingsData(
            username: username,
            isNotificationsEnabled: isNotificationsEnabled,
            volume: volume
        )
        storage.save(data)
    }
}
