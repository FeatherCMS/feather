import FeatherOpenAPI

extension Campaign.Schemas {
    struct Email: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AppNewsletterEmailField" }
    }
}
