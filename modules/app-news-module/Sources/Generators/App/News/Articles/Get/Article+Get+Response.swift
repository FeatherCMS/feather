public import FeatherOpenAPI

extension Article.Get {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "NewsArticleDetailResponse" }
        public var description: String = "News item detail"
        public var schema = Article.Schemas.Detail().reference()

        public init() {}
    }
}
