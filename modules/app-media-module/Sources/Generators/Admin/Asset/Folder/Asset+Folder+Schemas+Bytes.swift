import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct Bytes: Int64SchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderBytesField" }
    }
}
