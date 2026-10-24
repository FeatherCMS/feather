import FeatherOpenAPI

struct NewsletterCampaignResponse: JSONResponseRepresentable {
    var description: String = "Newsletter response"
    var schema = NewsletterCampaignSchema().reference()
}
struct NewsletterCampaignListResponse: JSONResponseRepresentable {
    var description: String = "Newsletter list response"
    var schema = NewsletterCampaignListSchema().reference()
}
