public import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct WebMetadataResponse: JSONResponseRepresentable {
    public var description: String = "Web metadata resolution"
    public var schema = WebMetadataSchema().reference()

    public init() {}
}

public struct WebMetadataListResponse: JSONResponseRepresentable {
    public var description: String = "Public web metadata slugs"
    public var schema = WebMetadataSlugListSchema().reference()

    public init() {}
}
