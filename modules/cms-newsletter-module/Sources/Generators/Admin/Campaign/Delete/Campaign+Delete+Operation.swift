import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Delete {
    struct Operation: Campaign.Operation, DeleteOperation {
        var operationId: String? { "newsletterCampaignRemove" }
    }
}
