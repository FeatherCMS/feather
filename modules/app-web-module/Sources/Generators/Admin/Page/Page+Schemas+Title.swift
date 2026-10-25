import FeatherOpenAPI

extension Page.Schemas {
    struct Title: StringSchemaRepresentable {
        var openAPIIdentifier: String { "PageTitleField" }
        var example: String? = "Homepage"
    }
}
