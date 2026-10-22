public import FeatherApplication
public import NewsDomain

extension Category {
    public enum List {}
}

extension Category.List {
    public struct Input: DTO {
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

                public init(field: Field, direction: Search.SortDirection) {
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

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
