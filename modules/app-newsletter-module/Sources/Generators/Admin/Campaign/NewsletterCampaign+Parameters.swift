import FeatherOpenAPI

struct NewsletterCampaignKeyParameter: PathParameterRepresentable {
    var name: String { "newsletterCampaignKey" }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterKeyField().reference()
    }
}
