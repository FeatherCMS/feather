public import FeatherApplication
public import SystemModule

extension Variable.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case key, name, value, notes
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
            public var ids: [String]?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                ids: [String]? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.ids = ids
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
