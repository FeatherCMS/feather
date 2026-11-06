public import FeatherApplication
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Metadata.Resolve {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let referenceType: String
            public let referenceID: String
            public let slug: String
            public let publicationDate: Date
            public let expirationDate: Date?
            public let status: Metadata.Model.Status
            public let title: String
            public let createdAt: Date
            public let updatedAt: Date

            public init(
                id: String,
                referenceType: String,
                referenceID: String,
                slug: String,
                publicationDate: Date,
                expirationDate: Date?,
                status: Metadata.Model.Status,
                title: String,
                createdAt: Date,
                updatedAt: Date
            ) {
                self.id = id
                self.referenceType = referenceType
                self.referenceID = referenceID
                self.slug = slug
                self.publicationDate = publicationDate
                self.expirationDate = expirationDate
                self.status = status
                self.title = title
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
