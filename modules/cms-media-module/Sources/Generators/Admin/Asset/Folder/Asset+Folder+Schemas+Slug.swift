import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct Slug: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderSlugField" }
        var example: String? { "posts" }
    }
}
