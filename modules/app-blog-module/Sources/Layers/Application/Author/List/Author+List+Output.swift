public import BlogModule
public import FeatherApplication

public import struct Foundation.Date

extension Author.List {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let name: String
            public let excerpt: String
            public let profileImageAssetId: String?
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                id: String,
                name: String,
                excerpt: String,
                profileImageAssetId: String?,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.name = name
                self.excerpt = excerpt
                self.profileImageAssetId = profileImageAssetId
                self.createdAt = createdAt
                self.updatedAt = updatedAt
            }
        }

        public let items: [Item]

        package init(items: [Item]) {
            self.items = items
        }
    }
}
