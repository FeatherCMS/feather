import FeatherOpenAPI

struct NewsletterCampaignPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignListOperation() }
    var post: OperationRepresentable? { NewsletterCampaignCreateOperation() }
    var delete: OperationRepresentable? {
        NewsletterCampaignDeleteOperation()
    }
}
struct NewsletterCampaignIDPathItems: PathItemRepresentable {
    var get: OperationRepresentable? { NewsletterCampaignGetOperation() }
    var patch: OperationRepresentable? { NewsletterCampaignUpdateOperation() }
}
