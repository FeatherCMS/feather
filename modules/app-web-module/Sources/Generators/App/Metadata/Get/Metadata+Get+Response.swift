import FeatherOpenAPI

extension Metadata.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MetadataResponse" }
        var description: String = "Web metadata resolution"
        var schema: some SchemaRepresentable { MetadataSchema().reference() }
    }
}
