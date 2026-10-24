import FeatherOpenAPI

extension NewsletterCampaign.Query {
    enum Schemas {}
}

extension NewsletterCampaign.Query.Schemas {
    struct Item: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignQueryItemSchema" }

        var propertyMap: SchemaMap {
            [
                "id": NewsletterIdField().reference(),
                "key": NewsletterKeyField().reference(),
                "name": NewsletterNameField().reference(),
                "fromEmail": NewsletterEmailField().reference(),
            ]
        }
    }
}
