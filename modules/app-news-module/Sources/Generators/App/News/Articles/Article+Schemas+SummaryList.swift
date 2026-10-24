public import FeatherOpenAPI
import OpenAPIKit30

public extension Article.Schemas {
    struct SummaryList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsArticleSummaryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
