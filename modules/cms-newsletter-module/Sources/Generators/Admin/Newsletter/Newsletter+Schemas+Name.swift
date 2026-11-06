import FeatherOpenAPI

extension Newsletter.Schemas {
    struct Name: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterNameField" }
    }
}
