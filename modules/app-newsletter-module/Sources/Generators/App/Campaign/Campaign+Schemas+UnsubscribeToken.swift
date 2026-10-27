import FeatherOpenAPI

extension Campaign.Schemas {
    struct UnsubscribeToken: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AppNewsletterUnsubscribeTokenField" }
    }
}
