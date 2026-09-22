import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/newsletter/campaign/{newsletterCampaignKey}/subscribe":
                AppNewsletterCampaignSubscribePathItems(),
            "api/v1/newsletter/campaign/{newsletterCampaignKey}/unsubscribe":
                AppNewsletterCampaignUnsubscribePathItems(),
        ]
    }
}
