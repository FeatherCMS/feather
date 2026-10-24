import FeatherOpenAPI

struct AppNewsletterCampaignSubscriptionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AppNewsletterCampaignSubscriptionSchema().reference())]
    }
}
