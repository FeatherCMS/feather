public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct MetadataResponse: JSONResponseRepresentable {
    public var description: String = "Web metadata resolution"
    public var schema = MetadataSchema().reference()

    public init() {}
}

public struct MetadataListResponse: JSONResponseRepresentable {
    public var description: String = "Public web metadata slugs"
    public var schema = MetadataSlugListSchema().reference()

    public init() {}
}
