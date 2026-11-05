import FeatherOpenAPI

extension Metadata.Schemas {
    struct ReferenceID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataReferenceIDField" }
        var example: String? = "wp_home"
    }
}
