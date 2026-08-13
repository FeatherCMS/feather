import FeatherOpenAPI

struct NewsletterCampaignIdParameter: PathParameterRepresentable {
    var name: String { "newsletterCampaignId" }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterIdField().reference()
    }
}
