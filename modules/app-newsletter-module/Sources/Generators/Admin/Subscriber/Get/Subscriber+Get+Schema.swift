import FeatherOpenAPI

extension Subscriber.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID(),
                "campaignKey": Newsletter.Schemas.Key(),
                "email": Newsletter.Schemas.Email(),
                "status": Subscriber.Schemas.Status(),
                "subscriptionDate": Newsletter.Schemas.Timestamp(),
                "unsubscriptionDate": Newsletter.Schemas.Timestamp()
                    .reference(required: false),
                "firstName": Newsletter.Schemas.Name()
                    .reference(required: false),
                "lastName": Newsletter.Schemas.Name()
                    .reference(required: false),
                "createdAt": Newsletter.Schemas.Timestamp(),
                "updatedAt": Newsletter.Schemas.Timestamp(),
            ]
        }
    }
}
