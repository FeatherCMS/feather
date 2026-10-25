import FeatherOpenAPI

extension Campaign.Query {
    enum Schemas {}
}

extension Campaign.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignQueryItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": Newsletter.Schemas.ID().reference(),
                "key": Newsletter.Schemas.Key().reference(),
                "name": Newsletter.Schemas.Name().reference(),
                "fromEmail": Newsletter.Schemas.Email().reference(),
            ]
        }
    }
}
