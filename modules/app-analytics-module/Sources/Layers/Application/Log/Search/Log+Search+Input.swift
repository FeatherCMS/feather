import AnalyticsDomain
public import AnalyticsModule
public import FeatherApplication

extension Log {
    public enum Search {}
}

extension Log.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case accountId
                    case method
                    case source
                    case path
                    case responseCode
                    case ip
                    case browserName
                    case createdAt
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
            public let source: String?
            public let method: String?
            public let responseCode: Int?
            public let from: Double?
            public let to: Double?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                source: String? = nil,
                method: String? = nil,
                responseCode: Int? = nil,
                from: Double? = nil,
                to: Double? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.source = source
                self.method = method
                self.responseCode = responseCode
                self.from = from
                self.to = to
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
