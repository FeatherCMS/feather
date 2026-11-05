import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderNameField" }
        var example: String? { "Posts" }
    }
}
