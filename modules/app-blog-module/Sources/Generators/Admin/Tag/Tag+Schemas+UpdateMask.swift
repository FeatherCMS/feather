import FeatherOpenAPI

extension Tag.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogTagUpdateMaskField" }
        var example: String? = "title,imageAssetId"
    }
}
