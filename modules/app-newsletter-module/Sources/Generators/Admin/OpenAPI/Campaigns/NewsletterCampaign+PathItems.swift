import FeatherOpenAPI

struct NewsletterCampaignPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignListOperation() }
    var post: OperationRepresentable? { NewsletterCampaignCreateOperation() }
    var delete: OperationRepresentable? { NewsletterCampaignBulkDeleteOperation() }
}
struct NewsletterCampaignIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignGetOperation() }
    var patch: OperationRepresentable? { NewsletterCampaignUpdateOperation() }
}
