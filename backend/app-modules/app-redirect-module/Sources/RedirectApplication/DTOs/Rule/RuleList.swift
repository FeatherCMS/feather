import Application
import struct Foundation.Date

public struct RuleList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let source: String
        public let destination: String
        public let statusCode: Int
        public let notes: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            source: String,
            destination: String,
            statusCode: Int,
            notes: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.source = source
            self.destination = destination
            self.statusCode = statusCode
            self.notes = notes
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case source
                case destination
                case statusCode
                case notes
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
        public var statusCode: Int?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil,
            statusCode: Int? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
            self.statusCode = statusCode
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
