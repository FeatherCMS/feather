import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/subscribers":
                    PathItem(),
                "api/v1/admin/newsletter/subscribers/query": Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/subscribers/{email}":
                    Email.PathItem(),
            ]
        }
    }
}
