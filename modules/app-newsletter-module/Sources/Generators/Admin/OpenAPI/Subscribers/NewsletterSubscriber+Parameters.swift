import FeatherOpenAPI

struct NewsletterSubscriberEmailParameter: PathParameterRepresentable {
    var name: String { "email" }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterEmailField().reference()
    }
}
