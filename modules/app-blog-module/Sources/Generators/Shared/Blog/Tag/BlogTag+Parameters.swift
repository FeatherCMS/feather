import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct BlogTagIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Blog tag identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        BlogTagIdField().reference()
    }

    public init() {}
}
