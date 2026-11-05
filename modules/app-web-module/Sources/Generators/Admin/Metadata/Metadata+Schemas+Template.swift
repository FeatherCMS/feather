import FeatherOpenAPI

extension Metadata.Schemas {
    struct Template: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MetadataTemplateField" }
        var example: String? = "default"
    }
}
