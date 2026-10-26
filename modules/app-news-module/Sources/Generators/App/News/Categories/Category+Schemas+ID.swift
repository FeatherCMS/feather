public import FeatherOpenAPI

extension Category.Schemas {
    public struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryIdField" }
        public var example: String? = "news_category_1"

        public init() {}
    }
}
