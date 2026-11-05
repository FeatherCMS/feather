import FeatherOpenAPI

extension Post.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "BlogPostUpdateMaskField" }
        var example: String? = "title,imageAssetId"
    }
}
