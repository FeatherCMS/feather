public import FeatherOpenAPI

public extension Category.Schemas {
    struct ImageURL: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryImageURLField" }
        public var example: String? = "/public/12/34/56789/originals/news-category.png"

        public init() {}
    }
}
