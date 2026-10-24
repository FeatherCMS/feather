public import FeatherApplication
import NewsModule

extension Public.Article.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case title
                    case createdAt
                    case updatedAt
                }

                public let field: Field
                public let direction: Search.SortDirection

                public init(field: Field, direction: Search.SortDirection) {
                    self.field = field
                    self.direction = direction
                }
            }

            public let page: Search.Page
            public let sort: [Sort]
            public let categoryID: String?

            public init(
                page: Search.Page = .init(),
                sort: [Sort] = [],
                categoryID: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.categoryID = categoryID
            }
        }

        public let limit: Int

        public init(limit: Int = 10000) {
            self.limit = limit
        }
    }
}
