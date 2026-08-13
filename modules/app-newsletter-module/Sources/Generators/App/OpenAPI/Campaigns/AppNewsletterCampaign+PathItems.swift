import FeatherOpenAPI

struct AppNewsletterCampaignSubscribePathItems: PathItemRepresentable {
    var post: OperationRepresentable? {
        AppNewsletterCampaignSubscribeOperation()
    }
}
struct AppNewsletterCampaignUnsubscribePathItems: PathItemRepresentable {
    var post: OperationRepresentable? {
        AppNewsletterCampaignUnsubscribeOperation()
    }
}
