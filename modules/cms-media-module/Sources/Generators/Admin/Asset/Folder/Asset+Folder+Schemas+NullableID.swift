import FeatherOpenAPI

extension Asset.Folder.Schemas {
    struct NullableID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "MediaFolderNullableIdField" }
        var required: Bool = false
        var nullable: Bool? = true
    }
}
