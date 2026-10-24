public import FeatherOpenAPI

public extension Article.Schemas {
    struct ImageURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleImageURLField" }
        public var example: String? = "/public/12/34/56789/originals/news.png"

        public init() {}
    }
}
