import FeatherOpenAPI

extension Campaign.Post {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignCreateSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Newsletter.Schemas.Key(),
                "name": Newsletter.Schemas.Name(),
                "fromEmail": Newsletter.Schemas.Email(),
            ]
        }
    }
}
