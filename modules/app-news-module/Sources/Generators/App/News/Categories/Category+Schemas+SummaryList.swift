public import FeatherOpenAPI
import OpenAPIKit30

public extension Category.Schemas {
    struct SummaryList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategorySummaryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
