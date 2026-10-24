import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterSubscriber {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/subscribers":
                    PathItem(),
                "api/v1/admin/newsletter/subscribers/query": Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/subscribers/{email}":
                    Email.PathItem(),
            ]
        }
    }
}
