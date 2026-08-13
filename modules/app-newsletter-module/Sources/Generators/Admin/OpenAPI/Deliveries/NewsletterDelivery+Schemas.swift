import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterDeliveryStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["pending", "sent", "failed", "bounced"]
}

struct NewsletterDeliverySchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "subscriberEmail": NewsletterEmailField(),
            "status": NewsletterSubscriberStatusField(),
            "sentAt": NewsletterTimestampField().reference(required: false),
            "failureReason": NewsletterContentField()
                .reference(required: false),
            "createdAt": NewsletterTimestampField(),
            "updatedAt": NewsletterTimestampField(),
        ]
    }
}

struct NewsletterDeliveryListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        NewsletterDeliverySchema().reference()
    }
}
