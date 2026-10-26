import FeatherOpenAPI

extension Metadata.Schemas {
    struct ReferenceType: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataReferenceTypeField" }
        var example: String? = "web.page"
    }
}
