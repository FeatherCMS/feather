import FeatherOpenAPI

extension Issue.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueIdParameter" }
        var name: String { "newsletterIssueId" }
        var schema: any OpenAPISchemaRepresentable {
            Newsletter.Schemas.ID().reference()
        }
    }
}
