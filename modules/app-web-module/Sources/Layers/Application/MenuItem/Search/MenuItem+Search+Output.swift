public import FeatherApplication
public import WebModule

public import struct Foundation.Date

extension MenuItem.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let menuId: String
            public let label: String
            public let url: String
            public let priority: Int
            public let isBlank: Bool
            public let permission: String
            public let authentication: MenuItem.Authentication
            public let createdAt: Date
            public let updatedAt: Date

            public init(
                id: String,
                menuId: String,
                label: String,
                url: String,
                priority: Int,
                isBlank: Bool,
                permission: String,
                authentication: MenuItem.Authentication,
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
                self.authentication = authentication
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let items: [Item]
        public let total: Int

        public init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
