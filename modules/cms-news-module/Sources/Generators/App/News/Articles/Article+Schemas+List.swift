public import FeatherOpenAPI

extension Article.Schemas {
    public struct List: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
