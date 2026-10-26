import FeatherOpenAPI

extension Campaign.List {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "NewsletterCampaignListResponse" }
        var description: String = "Newsletter list response"
        var schema = Schema().reference()
    }
}
