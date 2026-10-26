public import FeatherOpenAPI

extension Article.Schemas {
    public struct ImageURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleImageURLField" }
        public var example: String? = "/public/12/34/56789/originals/news.png"

        public init() {}
    }
}
