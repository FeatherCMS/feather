import Application
import struct Foundation.Date

public struct MenuItemList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            menuId: String,
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool,
            permission: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.menuId = menuId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case label
                case url
                case priority
                case permission
                case createdAt
                case updatedAt
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

    public init(items: [Item]) {
        self.items = items
    }
}
