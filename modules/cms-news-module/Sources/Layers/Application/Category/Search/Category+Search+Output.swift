public import FeatherApplication
import NewsDomain
public import NewsModule

public import struct Foundation.Date

extension Category.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let title: String
            public let excerpt: String
            public let imageAssetId: String?
            public let createdAt: Date
            public let updatedAt: Date

            public init(
                id: String,
                title: String,
                excerpt: String,
                imageAssetId: String?,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.title = title
                self.excerpt = excerpt
                self.imageAssetId = imageAssetId
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
