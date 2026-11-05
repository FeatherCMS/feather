import FeatherOpenAPI

extension Newsletter.Schemas {
    struct Content: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterContentField" }
    }
}
