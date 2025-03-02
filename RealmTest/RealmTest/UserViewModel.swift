//
//  UserViewModel.swift
//  RealmTest
//
//  Created by 柿崎 on 2025/03/02.
//

import SwiftUI
import RealmSwift

@MainActor
class UserViewModel: ObservableObject {
    private var realm: Realm

    @Published var users: [User] = []

    init() {
        realm = try! Realm()
        loadUsers()
    }

    private func loadUsers() {
        let results = realm.objects(User.self)
        users = results.map { $0 }
    }

    func addUser(name: String, age: Int) {
        let user = User()
        user.id = UUID().uuidString
        user.name = name
        user.age = age

        try! realm.write {
            realm.add(user)
        }
        loadUsers()
    }

    func printRealmPath() {
        if let realmURL = realm.configuration.fileURL {
            print("Realm file path: \(realmURL)")
        }
    }
}
