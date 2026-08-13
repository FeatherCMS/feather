//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

public struct AccountModel: Object {

    public struct UserModel: Object {
        public let id: String
        public let email: String

        public init(
            id: String,
            email: String = ""
        ) {
            self.id = id
            self.email = email
        }
    }

    public let user: UserModel
    public let permissions: [String]
    public let roles: [String]

    public init(
        user: UserModel,
        permissions: [String],
        roles: [String]
    ) {
        self.user = user
        self.permissions = permissions
        self.roles = roles
    }

    public var permissionSet: Set<String> {
        Set(permissions)
    }

    public func canAccess(
        _ permission: String
    ) -> Bool {
        permissionSet.contains(permission)
    }
}
