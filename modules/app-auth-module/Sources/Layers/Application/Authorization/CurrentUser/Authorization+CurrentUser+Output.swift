public import AuthModule
public import FeatherApplication
public import UserDomain
public import UserModule

public import struct Foundation.Date

extension AuthModule.Authorization.CurrentUser {
    public struct Output: DTO, Sendable {
        public struct User: DTO, Sendable {
            public let id: String
            public let name: String
            public let roleIds: [String]
            public let status: Identity.Model.Status
            public let createdAt: Date
            public let updatedAt: Date

            public init(
                id: String,
                name: String,
                roleIds: [String],
                status: Identity.Model.Status,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.name = name
                self.roleIds = roleIds
                self.status = status
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let user: User
        public let roles: [String]
        public let permissions: [String]

        public init(
            user: User,
            roles: [String],
            permissions: [String]
        ) {
            self.user = user
            self.roles = roles
            self.permissions = permissions
        }
    }
}
