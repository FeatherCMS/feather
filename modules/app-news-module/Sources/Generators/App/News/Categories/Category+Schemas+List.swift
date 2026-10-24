public import FeatherOpenAPI
import OpenAPIKit30

public extension Category.Schemas {
    struct List: ArraySchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryListSchema" }
        public var items: (any SchemaRepresentable)? {
            Summary().reference()
        }

        public init() {}
    }
}
