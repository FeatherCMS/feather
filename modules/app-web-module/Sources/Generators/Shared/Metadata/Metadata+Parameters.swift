public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct MetadataIdParameter: PathParameterRepresentable {
    public var name: String { "id" }
    public var description: String? { "Web metadata identifier" }
    public var schema: any OpenAPISchemaRepresentable {
        MetadataReferenceIDField().reference()
    }

    public init() {}
}

public struct MetadataSlugParameter: PathParameterRepresentable {
    public var name: String { "slug" }
    public var description: String? { "Web metadata slug" }
    public var schema: any OpenAPISchemaRepresentable {
        MetadataSlugField().reference()
    }

    public init() {}
}
