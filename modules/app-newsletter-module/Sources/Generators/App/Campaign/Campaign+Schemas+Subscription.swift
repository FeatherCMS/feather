import FeatherOpenAPI

extension Campaign.Schemas {
    struct Subscription: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "AppNewsletterCampaignSubscriptionSchema" }
        var propertyMap: SchemaMap {
            [
                "email": Email(),
                "firstName": Name().reference(required: false),
                "lastName": Name().reference(required: false),
            ]
        }
    }
}
