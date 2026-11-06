public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Session.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
                    case createdAt
                }

                public let field: Field
                public let direction: Search.SortDirection

                public init(field: Field, direction: Search.SortDirection) {
                    self.field = field
                    self.direction = direction
                }
            }

            public let page: Search.Page
            public let sort: [Sort]
            public let search: String?

            public init(
                page: Search.Page = .init(),
                sort: [Sort] = [],
                search: String? = nil
            ) {
                self.page = page
                self.sort = sort
                self.search = search
            }
        }

        public let identityId: String
        public let query: Query

        public init(identityId: String, query: Query) {
            self.identityId = identityId
            self.query = query
        }
    }
}
