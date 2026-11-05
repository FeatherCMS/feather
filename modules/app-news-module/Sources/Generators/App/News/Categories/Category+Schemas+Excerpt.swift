public import FeatherOpenAPI

extension Category.Schemas {
    public struct Excerpt: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryExcerptField" }
        public var example: String? = "Short news category summary."

        public init() {}
    }
}
