//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

struct AccountModel: Object {

    struct UserModel: Object {
        let id: String
        let email: String
    }

    let user: UserModel
    let permissions: [String]
    let roles: [String]

    var permissionSet: Set<String> {
        Set(permissions)
    }

    var isRoot: Bool {
        roles.contains("root")
    }

    func canAccess(
        _ permission: String
    ) -> Bool {
        permissionSet.contains(permission)
    }
}
