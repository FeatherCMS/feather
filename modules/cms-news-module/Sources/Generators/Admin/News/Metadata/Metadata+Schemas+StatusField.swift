import FeatherOpenAPI

extension Metadata.Schemas {
    struct StatusField: StringSchemaRepresentable {
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]
    }
}
