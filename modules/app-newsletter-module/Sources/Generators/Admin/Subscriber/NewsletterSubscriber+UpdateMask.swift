import FeatherOpenAPI

struct NewsletterSubscriberUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? { "Comma-separated list of fields to update." }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterSubscriberUpdateMaskSchema().reference()
    }
}

struct NewsletterSubscriberUpdateMaskSchema: StringSchemaRepresentable {
    var openAPIIdentifier: String { "NewsletterSubscriberUpdateMask" }
    var example: String? { "firstName,lastName,status" }
}
