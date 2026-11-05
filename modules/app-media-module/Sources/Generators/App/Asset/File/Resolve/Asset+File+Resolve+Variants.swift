import FeatherOpenAPI

extension Asset.File.Resolve {
    struct Variants: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveVariantsField" }
        var items: (any SchemaRepresentable)? { Asset.File.Schemas.Key() }
    }
}
