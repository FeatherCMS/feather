import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogAuthorIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Blog author identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        BlogAuthorIdField().reference()
    }

    public init() {}
}
