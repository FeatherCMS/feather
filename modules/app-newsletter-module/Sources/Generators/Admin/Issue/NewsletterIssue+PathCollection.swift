import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue {
    struct PathCollection: PathCollectionRepresentable {
        var pathMap: PathMap {
            [
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues":
                    PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/query":
                    Query.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/test-email":
                    TestEmail.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}":
                    ID.PathItem(),
                "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}/test-email":
                    ID.TestEmail.PathItem(),
            ]
        }
    }
}
