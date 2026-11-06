import FeatherOpenAPI

extension Asset.File.Query.Schemas {
    struct ItemKind: StringSchemaRepresentable {
        var enumValues: [String]? = ["file", "folder"]
    }
}
