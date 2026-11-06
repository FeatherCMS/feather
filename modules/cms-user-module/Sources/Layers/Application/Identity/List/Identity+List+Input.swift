public import FeatherApplication
public import UserModule

extension Identity.List {
    public struct Input: DTO {
        public struct Query: Sendable {
            public var limit: Int?
            public var search: String?
            public var role: String?

            public init(
                limit: Int? = nil,
                search: String? = nil,
                role: String? = nil
            ) {
                self.limit = limit
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
