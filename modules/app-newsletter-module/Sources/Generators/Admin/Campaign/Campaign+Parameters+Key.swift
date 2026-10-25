import FeatherOpenAPI

extension Campaign.Parameters {
    struct Key: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignKeyParameter" }
        var name: String { "newsletterCampaignKey" }
        var schema: any OpenAPISchemaRepresentable {
            Newsletter.Schemas.Key().reference()
        }
    }
}
