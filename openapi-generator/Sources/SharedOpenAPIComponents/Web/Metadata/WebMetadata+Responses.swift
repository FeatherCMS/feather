import FeatherOpenAPI

public struct WebMetadataResponse: JSONResponseRepresentable {
    public var description: String = "Web metadata resolution"
    public var schema = WebMetadataSchema().reference()

    public init() {}
}
