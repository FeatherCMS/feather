public import FeatherOpenAPI

public extension Category.List {
    struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryListResponse" }
        public var description: String = "News category list"
        public var schema = Category.Schemas.List().reference()

        public init() {}
    }
}
