public import FeatherOpenAPI

extension Article.Schemas {
    public struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleIdField" }
        public var example: String? = "news_1"

        public init() {}
    }
}
