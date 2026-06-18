import FeatherOpenAPI

public struct RedirectSourceParameter: QueryParameterRepresentable {
    public var name: String { "source" }
    public var description: String? { "Public redirect source path" }
    public var schema: any OpenAPISchemaRepresentable {
        RedirectSourceField().reference()
    }

    public init() {}
}
