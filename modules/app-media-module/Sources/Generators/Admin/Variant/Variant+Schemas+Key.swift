import FeatherOpenAPI

extension Variant.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantKeyField" }
        var example: String? = "preview"
    }
}
