import FeatherOpenAPI

extension Campaign.Parameters {
    struct Key: PathParameterRepresentable {
        var openAPIIdentifier: String { "AppNewsletterCampaignKeyParameter" }
        var name: String { "newsletterCampaignKey" }
        var schema: any OpenAPISchemaRepresentable { Campaign.Schemas.Key().reference() }
    }
}
