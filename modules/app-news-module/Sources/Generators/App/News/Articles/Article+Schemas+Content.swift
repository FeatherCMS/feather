public import FeatherOpenAPI

public extension Article.Schemas {
    struct Content: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleContentField" }
        public var example: String? = "<p>Hello world</p>"

        public init() {}
    }
}
