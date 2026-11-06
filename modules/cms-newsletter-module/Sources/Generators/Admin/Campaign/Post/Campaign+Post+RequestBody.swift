import FeatherOpenAPI

extension Campaign.Post {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "NewsletterCampaignCreateRequestBody"
        }
        var schema = Schema().reference()
    }
}
