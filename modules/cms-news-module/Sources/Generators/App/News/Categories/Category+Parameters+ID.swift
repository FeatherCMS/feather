public import FeatherOpenAPI

extension Category.Parameters {
    public struct ID: PathParameterRepresentable {
        public var openAPIIdentifier: String { "NewsCategoryIdParameter" }
        public var name: String { "id" }
        public var description: String? { "News category identifier" }
        public var schema: any OpenAPISchemaRepresentable {
            Category.Schemas.ID().reference()
        }

        public init() {}
    }
}
