import FeatherOpenAPI

extension Page {
    enum Schemas {
        struct UpdateMask: StringSchemaRepresentable {
            var openAPIIdentifier: String { "WebPageUpdateMask" }
            var example: String? { "title,content,imageAssetId" }
        }
    }
}
