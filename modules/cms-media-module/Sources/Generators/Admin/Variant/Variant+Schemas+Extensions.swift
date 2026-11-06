import FeatherOpenAPI

extension Variant.Schemas {
    struct Extensions: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantExtensionsField" }
        var example: String? = "png,jpg,jpeg,bmp"
    }
}
