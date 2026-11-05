import FeatherOpenAPI

extension Subscriber.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "email": Newsletter.Schemas.Email(),
                "firstName": Newsletter.Schemas.Name()
                    .reference(required: false),
                "lastName": Newsletter.Schemas.Name()
                    .reference(required: false),
                "status": Subscriber.Schemas.Status()
                    .reference(required: false),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "NewsletterSubscriberCreateRequestBody"
        }
        var schema = Schema().reference()
    }
}
