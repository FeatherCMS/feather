public import FeatherOpenAPI

extension Article.Schemas {
    public struct Content: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleContentField" }
        public var example: String? = "<p>Hello world</p>"

        public init() {}
    }
}
