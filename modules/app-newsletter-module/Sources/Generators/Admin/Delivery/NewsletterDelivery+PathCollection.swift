import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterDelivery {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}/deliveries":
                    PathItem()
            ]
        }
    }
}
