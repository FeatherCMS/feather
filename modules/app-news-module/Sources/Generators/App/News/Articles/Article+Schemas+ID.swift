public import FeatherOpenAPI

public extension Article.Schemas {
    struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleIdField" }
        public var example: String? = "news_1"

        public init() {}
    }
}
