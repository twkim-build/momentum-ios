//
//  CustomTextField.swift
//  Momentum
//
//  Created by taewoo kim on 03.04.26.
//

import Foundation
import SwiftUI


struct UppercaseTextField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: uppercasedBinding)
    }

    private var uppercasedBinding: Binding<String> {
        Binding(
            get: { text },
            set: { text = $0.uppercased() }
        )
    }
}

struct LimitedTextField: View {
    let title: String
    let limit: Int
    @Binding var text: String

    var body: some View {
        TextField(title, text: limitedBinding)
    }

    private var limitedBinding: Binding<String> {
        Binding(
            get: { text },
            set: { text = String($0.prefix(limit)) }
        )
    }
}

struct OptionalTextField: View {
    let title: String
    @Binding var text: String?

    var body: some View {
        TextField(title, text: nonOptionalBinding)
    }

    private var nonOptionalBinding: Binding<String> {
        Binding(
            get: { text ?? "" },
            set: { text = $0.isEmpty ? nil : $0 }
        )
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let transform: (String) -> String

    init(
        _ title: String,
        text: Binding<String>,
        transform: @escaping (String) -> String = { $0 }
    ) {
        self.title = title
        self._text = text
        self.transform = transform
    }

    var body: some View {
        TextField(title, text: transformedBinding)
    }

    private var transformedBinding: Binding<String> {
        Binding(
            get: { text },
            set: { text = transform($0) }
        )
    }
}

struct IntTextField: View {
    let title: String
    @Binding var value: Int

    var body: some View {
        TextField(title, text: stringBinding)
            .keyboardType(.numberPad)
    }

    private var stringBinding: Binding<String> {
        Binding(
            get: { String(value) },
            set: { value = Int($0) ?? 0 }
        )
    }
}
