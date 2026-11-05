public import FeatherOpenAPI

extension Category.Schemas {
    public struct SummaryList: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategorySummaryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
