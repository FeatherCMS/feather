import FeatherOpenAPI

struct NewsletterCampaignPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignListOperation() }
    var post: OperationRepresentable? { NewsletterCampaignCreateOperation() }
}
struct NewsletterCampaignIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignGetOperation() }
    var patch: OperationRepresentable? { NewsletterCampaignUpdateOperation() }
    var delete: OperationRepresentable? { NewsletterCampaignDeleteOperation() }
}
