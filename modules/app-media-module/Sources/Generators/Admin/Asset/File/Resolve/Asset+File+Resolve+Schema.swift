import FeatherOpenAPI

extension Asset.File.Resolve {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetResolveSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }
}
