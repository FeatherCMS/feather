import FeatherOpenAPI

extension Article.Schemas {
    struct StringField: StringSchemaRepresentable {
        var example: String? = "example"
    }
}
