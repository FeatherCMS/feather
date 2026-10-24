public import FeatherOpenAPI

public extension Category.Schemas {
    struct ID: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryIdField" }
        public var example: String? = "news_category_1"

        public init() {}
    }
}
