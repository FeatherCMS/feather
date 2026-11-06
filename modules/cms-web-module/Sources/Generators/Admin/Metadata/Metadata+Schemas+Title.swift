import FeatherOpenAPI

extension Metadata.Schemas {
    struct Title: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataTitleField" }
        var example: String? = "Homepage metadata title"
    }
}
