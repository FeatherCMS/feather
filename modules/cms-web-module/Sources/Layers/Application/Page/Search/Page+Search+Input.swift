public import FeatherApplication
public import WebDomain
public import WebModule

extension Page.Search {
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
                public let direction: FeatherApplication.Search.SortDirection

                public init(
                    field: Field,
                    direction: FeatherApplication.Search.SortDirection
                ) {
                    self.field = field
                    self.direction = direction
                }
            }

            public let page: FeatherApplication.Search.Page
            public let sort: [Sort]
            public let search: String?
            public let status: Metadata.Model.Status?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                status: Metadata.Model.Status? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.status = status
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
