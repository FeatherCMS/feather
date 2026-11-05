public import FeatherApplication
public import MediaModule

extension Variant.Processor.Search {
    public struct Input: DTO {
        public struct Query: Sendable {
            public var page: Search.Page
            public var search: String?

            public init(page: Search.Page = .init(), search: String? = nil) {
                self.page = page
                self.search = search
            }
        }

        public let variantId: String
        public let query: Query
        public init(variantId: String, query: Query) {
            self.variantId = variantId
            self.query = query
        }
    }
}
