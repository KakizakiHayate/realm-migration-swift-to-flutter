//
//  User.swift
//  RealmTest
//
//  Created by 柿崎 on 2025/03/02.
//

import RealmSwift

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var age: Int
}

