public import FeatherOpenAPI

public extension Article.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleExcerptField" }
        public var example: String? = "Short article summary."

        public init() {}
    }
}
