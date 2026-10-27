import FeatherOpenAPI

extension Campaign.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignIDParameter" }
        var name: String { "newsletterCampaignId" }
        var schema: any OpenAPISchemaRepresentable {
            Newsletter.Schemas.ID().reference()
        }
    }
}
