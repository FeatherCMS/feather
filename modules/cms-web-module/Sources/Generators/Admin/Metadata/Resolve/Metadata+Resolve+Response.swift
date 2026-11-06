import FeatherOpenAPI

extension Metadata.Resolve {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MetadataResolveResponse" }
        var description: String = "Metadata resolve response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
