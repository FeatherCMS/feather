public import FeatherOpenAPI

extension Article.Schemas {
    public struct SummaryList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleSummaryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
