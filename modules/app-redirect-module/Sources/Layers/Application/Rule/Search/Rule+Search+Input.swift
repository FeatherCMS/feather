public import FeatherApplication
public import RedirectModule
public import RedirectDomain

extension Rule.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id, source, destination, statusCode, notes
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
            public let statusCode: Rule.Model.StatusCode?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                statusCode: Rule.Model.StatusCode? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.statusCode = statusCode
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
