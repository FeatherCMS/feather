public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Credential {
    public enum Search {}
}

extension Credential.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case userId
                    case email
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

        public let query: Query
        public let userId: String?

        public init(query: Query, userId: String? = nil) {
            self.query = query
            self.userId = userId
        }
    }
}
