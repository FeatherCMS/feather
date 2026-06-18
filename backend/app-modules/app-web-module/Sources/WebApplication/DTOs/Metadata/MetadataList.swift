import Application
import struct Foundation.Date
import WebDomain

public struct MetadataList: DTO {

    public struct Item: Sendable {
        public let referenceType: String?
        public let referenceID: String?
        public let id: String
        public let slug: String
        public let publicationDate: Date?
        public let expirationDate: Date?
        public let status: Metadata.Status
        public let title: String
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            referenceType: String?,
            referenceID: String?,
            id: String,
            slug: String,
            publicationDate: Date?,
            expirationDate: Date?,
            status: Metadata.Status,
            title: String,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.referenceType = referenceType
            self.referenceID = referenceID
            self.id = id
            self.slug = slug
            self.publicationDate = publicationDate
            self.expirationDate = expirationDate
            self.status = status
            self.title = title
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {

        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case referenceType
                case referenceID
                case slug
                case publicationDate
                case expirationDate
                case status
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
