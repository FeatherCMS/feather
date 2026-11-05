public import FeatherApplication
import NewsModule

extension Public.Article.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public let search: String?
            public let pageNumber: Int
            public let pageSize: Int

            public init(
                search: String? = nil,
                pageNumber: Int = 1,
                pageSize: Int = 12
            ) {
                self.search = search
                self.pageNumber = pageNumber
                self.pageSize = pageSize
            }
        }

        public let query: Query

        public init(query: Query) {
            self.query = query
        }
    }
}
