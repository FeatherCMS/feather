import Application
import struct Foundation.Date

public struct MediaAssetList: DTO {

    public struct Item: Sendable {
        public let id: String
        public let folderId: String?
        public let storageKey: String
        public let baseName: String
        public let type: String
        public let sizeBytes: Int64
        public let status: String
        public let title: String?
        public let altText: String?
        public let createdAt: Date
        public let updatedAt: Date

        public init(
            id: String,
            folderId: String?,
            storageKey: String,
            baseName: String,
            type: String,
            sizeBytes: Int64,
            status: String,
            title: String?,
            altText: String?,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.folderId = folderId
            self.storageKey = storageKey
            self.baseName = baseName
            self.type = type
            self.sizeBytes = sizeBytes
            self.status = status
            self.title = title
            self.altText = altText
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }

    public struct Query: Sendable {
        public struct Sort: Sendable {
            public enum Field: String, Sendable, CaseIterable {
                case id
                case storageKey
                case type
                case sizeBytes
                case status
                case title
                case createdAt
                case updatedAt
            }

            public var field: Field
            public var direction: Search.SortDirection

            public init(field: Field, direction: Search.SortDirection) {
                self.field = field
                self.direction = direction
            }
        }

        public var page: Search.Page
        public var sort: [Sort]
        public var search: String?
        public var parentId: String?

        public init(
            page: Search.Page = .init(),
            sort: [Sort] = [],
            search: String? = nil,
            parentId: String? = nil
        ) {
            self.page = page
            self.sort = sort
            self.search = search
            self.parentId = parentId
        }
    }

    public let items: [Item]

    public init(items: [Item]) {
        self.items = items
    }
}
