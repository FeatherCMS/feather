public import FeatherOpenAPI

public extension Article.Parameters {
    struct ID: PathParameterRepresentable {
        public var openAPIIdentifier: String { "NewsArticleIdParameter" }
        public var name: String { "id" }
        public var description: String? { "News item identifier" }
        public var schema: any OpenAPISchemaRepresentable {
            Article.Schemas.ID().reference()
        }

        public init() {}
    }
}
