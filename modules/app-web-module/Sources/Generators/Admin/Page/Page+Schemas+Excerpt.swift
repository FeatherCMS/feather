import FeatherOpenAPI

extension Page.Schemas {
    struct Excerpt: StringSchemaRepresentable {
        var openAPIIdentifier: String { "PageExcerptField" }
        var example: String? = "Short page summary."
    }
}
