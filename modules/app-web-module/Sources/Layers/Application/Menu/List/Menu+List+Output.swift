public import FeatherApplication
public import WebDomain

public import struct Foundation.Date

extension Menu.List {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let key: String
            public let name: String
            public let createdAt: Date
            public let updatedAt: Date

            public init(
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

        public init(items: [Item]) {
            self.items = items
        }
    }
}
