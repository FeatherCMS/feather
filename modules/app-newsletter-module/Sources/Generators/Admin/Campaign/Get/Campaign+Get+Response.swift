import FeatherOpenAPI

extension Campaign.Get {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignResponse" }
        var description: String = "Newsletter response"
        var schema = Schema().reference()
    }
}
