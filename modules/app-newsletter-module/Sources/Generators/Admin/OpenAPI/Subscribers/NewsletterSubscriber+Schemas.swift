import FeatherOpenAPI
import OpenAPIKit30

struct NewsletterSubscriberStatusField: StringSchemaRepresentable {
    var enumValues: [String]? = ["subscribed", "unsubscribed"]
}

struct NewsletterSubscriberSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": NewsletterIdField(),
            "newsletterId": NewsletterIdField(),
            "email": NewsletterEmailField(),
            "status": NewsletterDeliveryStatusField(),
            "subscriptionDate": NewsletterTimestampField(),
            "unsubscriptionDate": NewsletterTimestampField()
                .reference(required: false),
            "firstName": NewsletterNameField().reference(required: false),
            "lastName": NewsletterNameField().reference(required: false),
            "createdAt": NewsletterTimestampField(),
            "updatedAt": NewsletterTimestampField(),
        ]
    }
}

struct NewsletterSubscriberListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? { NewsletterSubscriberSchema().reference() }
}
struct NewsletterSubscriberCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": NewsletterEmailField(),
            "firstName": NewsletterNameField().reference(required: false),
            "lastName": NewsletterNameField().reference(required: false),
            "status": NewsletterSubscriberStatusField()
                .reference(required: false),
        ]
    }
}
struct NewsletterSubscriberPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "firstName": NewsletterNameField().reference(required: false),
            "lastName": NewsletterNameField().reference(required: false),
            "status": NewsletterSubscriberStatusField(),
        ]
    }
}
