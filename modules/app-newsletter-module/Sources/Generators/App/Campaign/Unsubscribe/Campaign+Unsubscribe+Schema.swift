import FeatherOpenAPI

extension Campaign.Unsubscribe {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String {
            "AppNewsletterCampaignUnsubscribeSchema"
        }
        var propertyMap: SchemaMap {
            ["token": Campaign.Schemas.UnsubscribeToken()]
        }
    }
}
