public import FeatherOpenAPI

public extension Article.List {
    struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "NewsArticleListResponse" }
        public var description: String = "News item list"
        public var schema = Article.Schemas.List().reference()

        public init() {}
    }
}
