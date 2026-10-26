import FeatherOpenAPI

extension Subscriber.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated list of fields to update." }
        var schema: any OpenAPISchemaRepresentable { Subscriber.Schemas.UpdateMask().reference() }
    }
}
