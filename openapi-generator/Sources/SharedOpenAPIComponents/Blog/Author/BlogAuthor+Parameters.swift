import FeatherOpenAPI

public struct BlogAuthorIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Blog author identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        BlogAuthorIdField().reference()
    }

    public init() {}
}
