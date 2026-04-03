//
//  BindingExtension.swift
//  Momentum
//
//  Created by taewoo kim on 02.04.26.
//

import Foundation

import SwiftUI

extension Binding where Value == String? {
    func orEmpty() -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0.isEmpty ? nil : $0 }
        )
    }
}

extension Binding where Value == String {
    func uppercased() -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = $0.uppercased() }
        )
    }

    func maxLength(_ limit: Int) -> Binding<String> {
        Binding<String>(
            get: { self.wrappedValue },
            set: { self.wrappedValue = String($0.prefix(limit)) }
        )
    }
}

extension Binding where Value == Int {
    func asString() -> Binding<String> {
        Binding<String>(
            get: { String(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) ?? 0 }
        )
    }
}
