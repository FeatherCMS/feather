import FeatherOpenAPI

extension Metadata.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MetadataListResponse" }
        var description: String = "Metadata list response"
        var schema: some SchemaRepresentable { Schema().reference() }
    }
}
