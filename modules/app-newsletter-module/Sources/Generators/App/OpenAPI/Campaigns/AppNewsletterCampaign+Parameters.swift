import FeatherOpenAPI

struct AppNewsletterCampaignIdParameter: PathParameterRepresentable {
    var name: String { "newsletterCampaignId" }
    var schema: any OpenAPISchemaRepresentable {
        AppNewsletterIdField().reference()
    }
}
