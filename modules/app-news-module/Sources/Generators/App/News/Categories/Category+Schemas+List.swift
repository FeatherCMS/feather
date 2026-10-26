public import FeatherOpenAPI

extension Category.Schemas {
    public struct List: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
