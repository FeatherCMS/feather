import FeatherOpenAPI

extension Campaign.Schemas {
    struct UpdateMask: StringSchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignUpdateMask" }
        var example: String? = "key,name,fromEmail"
    }
}
