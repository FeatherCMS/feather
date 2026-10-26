public import FeatherOpenAPI

public extension Category.Schemas {
    struct List: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
