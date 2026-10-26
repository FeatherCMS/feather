import FeatherOpenAPI

extension Subscriber.Parameters {
    struct Email: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterSubscriberEmailParameter" }
        var name: String { "email" }
        var schema: any OpenAPISchemaRepresentable { Newsletter.Schemas.Email().reference() }
    }
}
