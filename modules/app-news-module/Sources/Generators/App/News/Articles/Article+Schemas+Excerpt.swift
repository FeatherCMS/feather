public import FeatherOpenAPI

extension Article.Schemas {
    public struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleExcerptField" }
        public var example: String? = "Short article summary."

        public init() {}
    }
}
