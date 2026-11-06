import FeatherOpenAPI

extension Metadata.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "MetadataDetailResponse" }
        var description: String = "Metadata response"
        var schema: some SchemaRepresentable {
            MetadataDetailSchema().reference()
        }
    }
}
