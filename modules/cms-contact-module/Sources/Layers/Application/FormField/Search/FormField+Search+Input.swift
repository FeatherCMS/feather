public import ContactModule
public import FeatherApplication

extension FormField.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case key
                    case label
                    case type
                    case isRequired
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
            public let formKey: String?
            public let isUnassigned: Bool

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                formKey: String? = nil,
                isUnassigned: Bool = false
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.formKey = formKey
                self.isUnassigned = isUnassigned
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
