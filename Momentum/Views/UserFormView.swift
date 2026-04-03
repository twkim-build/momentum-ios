//
//  UserFormView.swift
//  Momentum
//
//  Created by taewoo kim on 03.04.26.
//

import Foundation
import SwiftUI
import Observation

@Observable
class UserFormModel {
    var username: String = ""
    var code: String = ""
    var nickname: String?
    var age: Int = 18
}

struct UserFormView: View {
    @State private var user = UserFormModel()

    var body: some View {
        Form {
            LimitedTextField(title: "Username", limit: 12, text: $user.username)

            UppercaseTextField(title: "Code", text: $user.code)

            OptionalTextField(title: "Nickname", text: $user.nickname)

            IntTextField(title: "Age", value: $user.age)

            Section("Preview") {
                Text("Username: \(user.username)")
                Text("Code: \(user.code)")
                Text("Nickname: \(user.nickname ?? "nil")")
                Text("Age: \(user.age)")
            }
        }
    }
}
