public import FeatherApplication
public import SystemModule

extension Permission.List {
    public struct Input: FeatherApplication.DTO {
        public struct Query: Sendable {
            public var limit: Int?
            public var search: String?
            public var ids: [String]?

            public init(
                limit: Int? = nil,
                search: String? = nil,
                ids: [String]? = nil
            ) {
                self.limit = limit
                self.search = search
                self.ids = ids
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
