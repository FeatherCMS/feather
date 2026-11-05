import FeatherOpenAPI

extension Variant.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaVariantUpdateMaskField" }
        var example: String? = "key,name,isRequired,isActive"
    }
}
