import Application
import struct Foundation.Date

public struct PageList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let createdAt: Date
        public let updatedAt: Date

        package init(
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

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case title
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
