import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Issue {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues":
                    PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/query":
                    Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/test-email":
                    TestEmail.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}":
                    ID.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}/test-email":
                    ID.TestEmail.PathItem(),
            ]
        }
    }
}
