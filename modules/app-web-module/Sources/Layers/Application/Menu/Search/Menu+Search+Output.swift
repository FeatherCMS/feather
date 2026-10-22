public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Menu.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                key: String,
                name: String,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.key = key
                self.name = name
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
