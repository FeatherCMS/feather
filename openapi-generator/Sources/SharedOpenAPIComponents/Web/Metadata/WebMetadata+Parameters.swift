import FeatherOpenAPI

public struct WebMetadataIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Web metadata identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        WebMetadataReferenceIDField().reference()
    }

    public init() {}
}

public struct WebMetadataSlugParameter: PathParameterRepresentable {
    public var name: String { "slug" }
    public var description: String? { "Web metadata slug" }
    public var schema: any OpenAPISchemaRepresentable {
        WebMetadataSlugField().reference()
    }

    public init() {}
}
