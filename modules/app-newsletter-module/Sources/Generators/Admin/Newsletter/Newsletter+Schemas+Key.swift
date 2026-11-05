import FeatherOpenAPI

extension Newsletter.Schemas {
    struct Key: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterKeyField" }
    }
}
