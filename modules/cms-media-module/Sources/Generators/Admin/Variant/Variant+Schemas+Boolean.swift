import FeatherOpenAPI

extension Variant.Schemas {
    struct Boolean: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantBooleanField" }
        var example: Bool? = true
    }
}
