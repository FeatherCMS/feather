public import AuthModule
public import FeatherApplication

public import struct Foundation.Date

extension RolePermission.Search {
    public struct Output: DTO, Sendable {
        public struct Item: Sendable {
            public let roleId: String
            public let permissionId: String
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                roleId: String,
                permissionId: String,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.roleId = roleId
                self.permissionId = permissionId
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let items: [Item]

        public init(items: [Item]) {
            self.items = items
        }
    }
}
