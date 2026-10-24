public import FeatherApplication
public import SystemModule

extension Variable.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case key, name, value, notes
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
            public var ids: [String]?

            public init(
                page: Search.Page = .init(),
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
        public init(query: Query) { self.query = query }
    }
}
