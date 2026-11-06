import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Delivery {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}/deliveries":
                    PathItem()
            ]
        }
    }
}
