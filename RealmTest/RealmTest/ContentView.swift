//
//  ContentView.swift
//  RealmTest
//
//  Created by 柿崎 on 2025/03/02.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        VStack {
            Button("Add User") {
                viewModel.addUser(name: "Test User", age: 25)
            }

            List(viewModel.users) { user in
                VStack(alignment: .leading) {
                    Text(user.name).font(.headline)
                    Text("Age: \(user.age)").font(.subheadline)
                }
            }

            Button("Print Realm Path") {
                viewModel.printRealmPath()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
