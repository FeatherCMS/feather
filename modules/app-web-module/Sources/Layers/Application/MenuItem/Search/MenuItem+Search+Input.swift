public import FeatherApplication
public import WebModule

extension MenuItem.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id, label, url, priority, permission, createdAt,
                        updatedAt
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

        public let menuId: String
        public let query: Query

        public init(menuId: String, query: Query) {
            self.menuId = menuId
            self.query = query
        }
    }
}
