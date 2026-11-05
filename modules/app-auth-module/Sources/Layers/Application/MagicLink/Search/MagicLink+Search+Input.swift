public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension MagicLink {
    public enum Search {}
}

extension MagicLink.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case credentialId
                    case token
                    case expiresAt
                    case isPersistent
                    case isUsed
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
            public let userId: String?

            public init(
                page: FeatherApplication.Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil,
                userId: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
                self.userId = userId
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
