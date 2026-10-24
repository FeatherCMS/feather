public import FeatherOpenAPI

public extension Category.Schemas {
    struct SummaryList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategorySummaryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
