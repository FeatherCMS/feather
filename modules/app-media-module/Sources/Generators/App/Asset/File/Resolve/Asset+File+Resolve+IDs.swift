import FeatherOpenAPI

extension Asset.File.Resolve {
    struct IDs: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveIDsField" }
        var items: (any SchemaRepresentable)? { Asset.File.Schemas.ID() }
    }
}
