import FeatherOpenAPI

extension Subscriber.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberStatusField" }
        var enumValues: [String]? = ["subscribed", "unsubscribed"]
    }
}
