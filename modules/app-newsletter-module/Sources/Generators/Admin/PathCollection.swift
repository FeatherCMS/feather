import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/newsletter/campaign": NewsletterCampaignPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}":
                NewsletterCampaignIDPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues":
                NewsletterIssuePathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/test-email":
                NewsletterCampaignTestEmailPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}":
                NewsletterIssueIDPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}/deliveries":
                NewsletterIssueDeliveryListPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/issues/{newsletterIssueId}/test-email":
                NewsletterIssueTestEmailPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/subscribers":
                NewsletterSubscriberPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignKey}/subscribers/{email}":
                NewsletterSubscriberIDPathItems(),
        ]
    }
}
