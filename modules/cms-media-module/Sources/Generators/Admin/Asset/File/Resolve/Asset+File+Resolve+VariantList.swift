import FeatherOpenAPI

extension Asset.File.Resolve {
    struct VariantList: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveVariantListField" }
        var items: (any SchemaRepresentable)? { VariantSchema().reference() }
    }
}
