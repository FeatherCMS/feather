public import FeatherOpenAPI

extension Category.Get {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryDetailResponse" }
        public var description: String = "News category detail"
        public var schema = Category.Schemas.Detail().reference()

        public init() {}
    }
}
