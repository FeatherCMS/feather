import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderTimestampField" }
        var example: Double? { 1_717_171_717 }
    }
}
