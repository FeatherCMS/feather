public import FeatherOpenAPI

public extension Article.Schemas {
    struct List: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
