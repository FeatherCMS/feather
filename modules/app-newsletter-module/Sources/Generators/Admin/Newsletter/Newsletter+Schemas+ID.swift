import FeatherOpenAPI

extension Newsletter.Schemas {
    struct ID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterIdField" }
    }
}
