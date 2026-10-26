import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderUpdateMaskField" }
        var example: String? { "name" }
    }
}
