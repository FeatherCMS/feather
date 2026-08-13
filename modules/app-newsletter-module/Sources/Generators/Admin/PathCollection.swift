import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/newsletter/campaign": NewsletterCampaignPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}":
                NewsletterCampaignIDPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues":
                NewsletterIssuePathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/test-email":
                NewsletterCampaignTestEmailPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}":
                NewsletterIssueIDPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}/deliveries":
                NewsletterIssueDeliveryListPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/issues/{newsletterIssueId}/test-email":
                NewsletterIssueTestEmailPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/subscribers":
                NewsletterSubscriberPathItems(),
            "api/v1/admin/newsletter/campaign/{newsletterCampaignId}/subscribers/{email}":
                NewsletterSubscriberIDPathItems(),
        ]
    }
}
