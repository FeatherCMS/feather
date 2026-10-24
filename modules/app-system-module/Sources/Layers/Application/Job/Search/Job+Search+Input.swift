public import FeatherApplication
public import SystemModule

extension Job.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case queuedAt
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

            public var page: Search.Page
            public var sort: [Sort]
            public var search: String?
            public var status: Int?

            public init(
                page: Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                status: Int? = nil
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
