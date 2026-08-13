import FeatherOpenAPI

struct NewsletterIssueIdParameter: PathParameterRepresentable {
    var name: String { "newsletterIssueId" }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterIdField().reference()
    }
}
