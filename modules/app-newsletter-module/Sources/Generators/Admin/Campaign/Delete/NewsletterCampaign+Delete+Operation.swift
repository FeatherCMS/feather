import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterCampaign.Delete {
    struct Operation: NewsletterCampaign.Operation, DeleteOperation {
        var operationId: String? { "newsletterCampaignRemove" }
    }
}
