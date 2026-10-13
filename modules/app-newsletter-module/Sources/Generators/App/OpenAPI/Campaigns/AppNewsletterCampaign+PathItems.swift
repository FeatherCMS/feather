import FeatherOpenAPI

struct AppNewsletterCampaignSubscribePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AppNewsletterCampaignSubscribeOperation()
    }
}
struct AppNewsletterCampaignUnsubscribePathItems: PathItemRepresentable {
    var post: (any OperationRepresentable)? {
        AppNewsletterCampaignUnsubscribeOperation()
    }
}
