public import BlogModule
public import FeatherApplication
import WebModule

extension AuthorLink.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case label
                    case url
                    case priority
                    case permission
                    case createdAt
                    case updatedAt
                }

                public var field: Field
                public var direction: FeatherApplication.Search.SortDirection

                public init(
                    field: Field,
                    direction: FeatherApplication.Search.SortDirection
                ) {
                    self.field = field
                    self.direction = direction
                }
            }

            public var page: FeatherApplication.Search.Page
            public var sort: [Sort]
            public var search: String?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
            }
        }

        public let authorId: String
        public let query: Query

        public init(authorId: String, query: Query) {
            self.authorId = authorId
            self.query = query
        }
    }
}
