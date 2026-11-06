import FeatherOpenAPI

extension Campaign.List {
    struct Schema: ArraySchemaRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignListSchema" }
        var items: (any SchemaRepresentable)? {
            Campaign.Get.Schema().reference()
        }
    }
}
