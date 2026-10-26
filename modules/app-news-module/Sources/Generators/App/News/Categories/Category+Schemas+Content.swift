public import FeatherOpenAPI

extension Category.Schemas {
    public struct Content: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryContentField" }
        public var example: String? = "<p>News category description</p>"

        public init() {}
    }
}
