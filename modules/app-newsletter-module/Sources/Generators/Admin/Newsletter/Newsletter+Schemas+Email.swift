import FeatherOpenAPI

extension Newsletter.Schemas {
    struct Email: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterEmailField" }
    }
}
