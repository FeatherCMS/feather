import FeatherOpenAPI
import OpenAPIKit30

struct AppNewsletterCampaignSubscriptionRequestBody: RequestBodyRepresentable {
    var contentMap: ContentMap {
        [.json: Content(AppNewsletterCampaignSubscriptionSchema().reference())]
    }
}
