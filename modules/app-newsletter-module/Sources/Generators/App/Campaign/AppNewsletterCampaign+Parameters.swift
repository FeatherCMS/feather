import FeatherOpenAPI

struct AppNewsletterCampaignKeyParameter: PathParameterRepresentable {
    var name: String { "newsletterCampaignKey" }
    var schema: any OpenAPISchemaRepresentable {
        AppNewsletterKeyField().reference()
    }
}
