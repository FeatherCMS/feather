import FeatherOpenAPI

extension Asset.Folder {
    struct Tag: TagRepresentable {
        var name: String = "MediaFolders"
        var description: String? = "Manage media folders."
    }
}
