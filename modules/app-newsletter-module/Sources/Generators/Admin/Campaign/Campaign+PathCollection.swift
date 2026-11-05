import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign": PathItem(),
                "api/v1/admin/newsletter/campaign/query": Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}":
                    ID.PathItem(),
            ]
        }
    }
}
