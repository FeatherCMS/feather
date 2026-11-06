import FeatherOpenAPI

extension Asset.File.Variant.Schemas {
    struct VariantType: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetVariantTypeField" }
        var example: String? { "processor" }
    }
}
