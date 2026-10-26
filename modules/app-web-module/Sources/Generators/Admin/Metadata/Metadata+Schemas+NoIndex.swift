import FeatherOpenAPI

extension Metadata.Schemas {
    struct NoIndex: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataNoIndexField" }
        var example: Bool? = false
    }
}
