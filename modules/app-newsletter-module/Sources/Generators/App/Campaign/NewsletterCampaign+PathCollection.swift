import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/newsletter/campaign/{newsletterCampaignKey}/subscribe":
                    Subscribe.PathItem(),
                "api/v1/newsletter/campaign/{newsletterCampaignKey}/unsubscribe":
                    Unsubscribe.PathItem(),
            ]
        }
    }
}
