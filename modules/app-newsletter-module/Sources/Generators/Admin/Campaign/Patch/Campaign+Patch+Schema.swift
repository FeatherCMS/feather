import FeatherOpenAPI

extension Campaign.Patch {
    struct Schema: ObjectSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignPatchSchema" }
        var propertyMap: SchemaMap {
            [
                "key": Newsletter.Schemas.Key().reference(required: false),
                "name": Newsletter.Schemas.Name().reference(required: false),
                "fromEmail": Newsletter.Schemas.Email()
                    .reference(required: false),
            ]
        }
    }
}
