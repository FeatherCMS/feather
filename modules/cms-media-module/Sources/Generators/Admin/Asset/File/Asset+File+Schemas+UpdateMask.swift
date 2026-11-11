import FeatherOpenAPI

extension Asset.File.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaAssetUpdateMaskField" }
        var example: String? { "name,title,altText" }
    }
}
