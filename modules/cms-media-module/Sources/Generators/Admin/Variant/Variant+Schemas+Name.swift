import FeatherOpenAPI

extension Variant.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantNameField" }
        var example: String? = "Preview"
    }
}
