import FeatherOpenAPI

extension Delivery.Schemas {
    struct Status: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterDeliveryStatusField" }
        var enumValues: [String]? = ["pending", "sent", "failed", "bounced"]
    }
}
