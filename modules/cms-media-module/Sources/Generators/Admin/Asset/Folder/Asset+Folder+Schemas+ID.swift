import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderIdField" }
        var example: String? { "media_folder_blog_posts" }
    }
}
