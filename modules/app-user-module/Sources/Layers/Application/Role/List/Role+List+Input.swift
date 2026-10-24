public import FeatherApplication
public import UserModule

extension Role.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public var page: Search.Page
            public var search: String?

            public init(
                page: Search.Page = .init(),
                search: String? = nil
            ) {
                self.page = page
                self.search = search
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
