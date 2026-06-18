import FeatherOpenAPI

public struct BlogPostIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Blog post identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        BlogPostIdField().reference()
    }

    public init() {}
}
