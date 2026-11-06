import FeatherOpenAPI

extension Asset.File.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetKeyField" }
        var example: String? { "preview" }
    }
}
