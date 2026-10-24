public import FeatherApplication
public import UserModule

extension Identity.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public var page: Search.Page
            public var search: String?
            public var role: String?

            public init(
                page: Search.Page = .init(),
                search: String? = nil,
                role: String? = nil
            ) {
                self.page = page
                self.search = search
                self.role = role
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
