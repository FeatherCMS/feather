public import FeatherOpenAPI

public extension Category.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryExcerptField" }
        public var example: String? = "Short news category summary."

        public init() {}
    }
}
