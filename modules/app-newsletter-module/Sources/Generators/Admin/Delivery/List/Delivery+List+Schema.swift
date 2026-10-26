import FeatherOpenAPI

extension Delivery.List {
    struct ItemSchema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterDeliverySchema" }
        var propertyMap: SchemaMap {
            [
                "subscriberEmail": Newsletter.Schemas.Email(),
                "status": Delivery.Schemas.Status().reference(),
                "sentAt": Newsletter.Schemas.Timestamp()
                    .reference(required: false),
                "failureReason": Newsletter.Schemas.Content()
                    .reference(required: false),
                "createdAt": Newsletter.Schemas.Timestamp(),
                "updatedAt": Newsletter.Schemas.Timestamp(),
            ]
        }
    }

    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterDeliveryListSchema" }
        var items: (any SchemaRepresentable)? { ItemSchema().reference() }
    }

    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterDeliveryListResponse" }
        var description: String = "Newsletter delivery list response"
        var schema = Schema().reference()
    }
}
