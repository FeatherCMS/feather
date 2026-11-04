import FeatherOpenAPI

extension Tag.Schemas {
    struct Status: StringSchemaRepresentable {
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]
    }
}
