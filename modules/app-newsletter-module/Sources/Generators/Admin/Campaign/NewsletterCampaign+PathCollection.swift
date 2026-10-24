import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign": PathItem(),
                "api/v1/admin/newsletter/campaign/query": Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}":
                    Key.PathItem(),
            ]
        }
    }
}
