public import FeatherApplication
public import MediaModule

extension Asset.File.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id, name, slugPath, `extension`, sizeBytes, status,
                        title,
                        createdAt, updatedAt
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

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
