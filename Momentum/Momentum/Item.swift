//
//  Item.swift
//  Momentum
//
//  Created by taewoo kim on 31.03.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
