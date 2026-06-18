import Application
import struct Foundation.Date

public struct RolePermissionList: DTO {

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

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case roleId
                case permissionId
            }

            public var field: Field
            public var direction: Search.SortDirection

            public init(
                field: Field,
                direction: Search.SortDirection
            ) {
                self.field = field
                self.direction = direction
            }
        }

        public var page: Search.Page
        public var sort: [Sort]
        public var search: String?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
        }
    }

    public let items: [Item]

    public init(
        items: [Item]
    ) {
        self.items = items
    }
}
