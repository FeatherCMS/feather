import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct Count: IntSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderCountField" }
        var example: Int? { 3 }
    }
}
