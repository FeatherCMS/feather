import FeatherOpenAPI

extension Author.Schemas {
    struct Status: StringSchemaRepresentable {
        var example: String? = "draft"
        var enumValues: [String]? = ["draft", "published", "archived"]
    }
}
