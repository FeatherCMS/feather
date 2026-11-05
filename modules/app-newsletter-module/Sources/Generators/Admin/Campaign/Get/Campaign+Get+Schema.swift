import FeatherOpenAPI

extension Campaign.Get {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignSchema" }
        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID(),
                "key": Newsletter.Schemas.Key(),
                "name": Newsletter.Schemas.Name(),
                "fromEmail": Newsletter.Schemas.Email(),
                "createdAt": Newsletter.Schemas.Timestamp(),
                "updatedAt": Newsletter.Schemas.Timestamp(),
            ]
        }
    }
}
