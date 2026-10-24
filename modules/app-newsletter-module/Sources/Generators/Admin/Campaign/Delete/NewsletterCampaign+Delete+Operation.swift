import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterCampaign.Delete {
    struct Operation: NewsletterCampaign.Operation, DeleteOperation {
        var operationId: String? { "newsletterCampaignRemove" }
    }
}
