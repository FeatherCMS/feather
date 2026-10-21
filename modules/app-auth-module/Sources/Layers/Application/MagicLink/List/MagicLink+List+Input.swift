public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension MagicLink.List {
    public struct Input: DTO {
        public let query: Query

        public init(query: Query) {
            self.query = query
        }

        public struct Query: Sendable {
            public struct Sort: Sendable {
                public enum Field: String, Sendable, CaseIterable {
                    case id
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
            public var userId: String?

            public init(
                page: Search.Page = .init(),
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
    }
}
