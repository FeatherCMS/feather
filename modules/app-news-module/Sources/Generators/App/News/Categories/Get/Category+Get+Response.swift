public import FeatherOpenAPI

public extension Category.Get {
    struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryDetailResponse" }
        public var description: String = "News category detail"
        public var schema = Category.Schemas.Detail().reference()

        public init() {}
    }
}
