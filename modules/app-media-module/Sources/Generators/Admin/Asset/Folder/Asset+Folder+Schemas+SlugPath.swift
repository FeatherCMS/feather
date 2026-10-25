import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct SlugPath: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderSlugPathField" }
        var example: String? { "blog/posts" }
    }
}
