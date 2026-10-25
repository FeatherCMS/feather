import FeatherOpenAPI

extension Subscriber.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "firstName": Newsletter.Schemas.Name().reference(required: false),
                "lastName": Newsletter.Schemas.Name().reference(required: false),
                "status": Subscriber.Schemas.Status().reference(required: false),
            ]
        }
    }

    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberPatchRequestBody" }
        var schema = Schema().reference()
    }
}
