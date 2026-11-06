public import FeatherApplication
public import UserModule

extension Role.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public var limit: Int?
            public var search: String?

            public init(
                limit: Int? = nil,
                search: String? = nil
            ) {
                self.limit = limit
                self.search = search
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
