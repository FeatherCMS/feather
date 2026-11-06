import FeatherOpenAPI

extension Subscriber.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberUpdateMask" }
        var example: String? { "firstName,lastName,status" }
    }
}
